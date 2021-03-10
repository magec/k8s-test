class kube_common {

  $conf_dir = '/var/lib/kubernetes'
  $yaml_dir = "${conf_dir}/yaml"
  $cluster_name = 'magec'
  $public_address = $network_info['balancer_dns_name']

  file { [$conf_dir, $yaml_dir]:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  $kubernetes_hostnames="kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.svc.cluster.local".split(',')
  $private_ip_addresses = $network_info['controllers'].map |$dns_name, $info| { $info['private_ip'] }

  $hostnames = [
    $network_info['service_cluster_first_ip'],
    $private_ip_addresses,
    $public_address,
    "127.0.0.1",
    $kubernetes_hostnames,
  ].flatten()

  cert { 'kubernetes':
    path      => $conf_dir,
    hostnames => $hostnames,
  }

  cert { 'service-account':
    path      => $conf_dir,
    hostnames => [],
  }

  file { "${conf_dir}/ca.pem":
    content => file(project_path('/secrets/ca.pem')),
  }

  file { "${conf_dir}/ca-key.pem":
    content => file(project_path('/secrets/ca-key.pem')),
  }

}
