# kube_controller_manager::install
class kube_controller_manager::install {
  archive { '/usr/bin/kube-controller-manager':
    source => "https://storage.googleapis.com/kubernetes-release/release/v1.18.6/bin/linux/amd64/kube-controller-manager",
    user   => 'root',
    group  => 'root',
  }

  file { '/usr/bin/kube-controller-manager':
    mode => '0755',
  }

}
