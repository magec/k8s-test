require 'open3'
Puppet::Functions.create_function(:'kubectl_config') do
  dispatch :kubectl_config do
    param 'String', :command
    param 'String', :config_file
  end

  def kubectl_config(command, config_file)
    return if File.exists?(config_file)
    stdout, stderr, status = Open3.capture3(["/usr/bin/kubectl", "config", command, "--kubeconfig=#{config_file}"].join(' '))

    raise "Error generating certificate: #{stderr}" unless status.success?
  end
end
