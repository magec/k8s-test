require 'open3'
require 'json'
Puppet::Functions.create_function(:'gen_cert') do
  dispatch :gen_cert do
    param 'String', :cn
    param 'Array[String]', :hostnames
  end

  def gen_cert(cn, hostnames)
    json_csr = {
      "CN" => cn,
      "key" => {
        "algo" => "rsa",
        "size" => 2048
      },
      "names" => [
        {
          "C" => "US",
          "L" => "Portland",
          "O" => "system:nodes",
          "OU" => "Kubernetes The Hard Way",
          "ST" => "Oregon"
        }
      ]
    }.to_json

    cfssl(
      command: 'gencert',
      json_request: json_csr,
      hostnames: hostnames
    )
  end

  def cfssl(command:, json_request:, hostnames:)
    secrets_dir = call_function('project_path', 'secrets')
    pki_dir = call_function('project_path', 'pki')
    opts = []
    opts << "-ca=#{secrets_dir}/ca.pem"
    opts << "-ca-key=#{secrets_dir}/ca-key.pem"
    opts << "-config=#{pki_dir}/ca-config.json"
    opts << "-hostname=#{hostnames.join(',')}" unless hostnames.empty?
    opts << "-profile=kubernetes"
    cl = "/usr/bin/cfssl #{command} #{opts.join(' ')} -"

    stdout, stderr, status = Open3.capture3(cl, stdin_data: json_request)
    raise "Error generating #{cl} certificate: #{stderr}" unless status.success?

    JSON.parse(stdout)
  end
end
