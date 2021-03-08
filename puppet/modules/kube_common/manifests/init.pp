class kube_common {

  $conf_dir = '/var/lib/kubernetes'
  $yaml_dir = "${conf_dir}/yaml"
  $cluster_name = 'magec'
  $public_address = "18.185.216.152"

  file { [$conf_dir, $yaml_dir]:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  $kubernetes_hostnames="kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.svc.cluster.local".split(',')
  $hostnames = [
    "10.32.0.1",
    "10.240.0.10",
    "10.240.0.11",
    "10.240.0.12",
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
