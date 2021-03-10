require 'aws-sdk-ec2'
require 'aws-sdk-elasticloadbalancing'
require 'yaml'
region = ENV['AWS_DEFAULT_REGION']

# Instances
ec2_resource = Aws::EC2::Resource.new(region: region)
controllers = ec2_resource.instances(filters: [
  {name: 'instance-state-name', values: ['running']},
  {name: 'tag:Role', values: ['Controller']}
])
workers = ec2_resource.instances(filters: [
  {name: 'instance-state-name', values: ['running']},
  {name: 'tag:Role', values: ['Worker']}
])

# Balancer
aws_load_balancing_client = Aws::ElasticLoadBalancing::Client.new
balancer_name = aws_load_balancing_client.describe_load_balancers.first['load_balancer_descriptions'].first.dns_name
def info(host)
  [
    host.private_dns_name.split('.').first, {
      'private_ip'  => host.private_ip_address,
      'private_dns' => host.private_dns_name,
      'tags'        => host.tags.map { |i| [i[:key], i[:value]] }.to_h
    }
  ]
end

service_cluster_ip_range = '10.32.0.0/24'
service_cluster_first_ip = '10.32.0.1'
info ={
  'network_info' => {
    'service_cluster_ip_range' => service_cluster_ip_range,
    'service_cluster_first_ip' => service_cluster_first_ip,
    'controllers'              => controllers.map { |i| info(i) }.to_h,
    'workers'                  => workers.map { |i| info(i) }.to_h,
    'balancer_dns_name'        => balancer_name,
  }
}

puts info.to_yaml
