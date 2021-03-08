include containerd
include crictl
include runc
include cni_plugins
include kubectl
include kube_proxy
include kubelet


# $cert_path = '/home/ubuntu'

# $hostnames = [$facts['ec2_metadata']['public-ipv4'], $ipaddress, $hostname]
# $instance_cert = gen_cert("system:node:${hostname}", $hostnames)
# File {
#   ensure  => 'file',
#   mode    => '0600',
#   owner   => 'root',
#   group   => 'root',
#   replace => false,
# }


# # @TODO: Refactor this
# file { "${cert_path}/${hostname}.pem":
#   content => $instance_cert["cert"],
# }
# file { "${cert_path}/${hostname}-key.pem":
#   content => $instance_cert["key"],
# }

# file { "${cert_path}/ca.pem":
#   content => file(project_path('/secrets/ca.pem')),
# }

# file { "${cert_path}/ca-key.pem":
#   content => file(project_path('/secrets/ca-key.pem')),
# }

# kubectl::config { 'kube-proxy':
#   commands => [
#     "set-cluster kubernetes-the-hard-way --certificate-authority=${project_path('secrets/ca.pem')} --embed-certs=true  --server=https://kubernetes:6443",
#     "set-credentials system:kube-proxy --client-certificate=${project_path('secrets/kube-proxy.pem')} --client-key=${project_path('secrets/kube-proxy-key.pem')}--embed-certs=true",
#     "set-context default --cluster=kubernetes-the-hard-way --user=system:kube-proxy",
#     "use-context default"
#   ]
# }
