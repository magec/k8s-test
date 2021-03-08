# kube_proxy::install
class kube_proxy::install {
  archive { '/usr/bin/kube-proxy':
    source => 'https://storage.googleapis.com/kubernetes-release/release/v1.18.6/bin/linux/amd64/kube-proxy',
    user   => 'root',
    group  => 'root',
  }

  file { '/usr/bin/kube-proxy':
    mode => '0755',
  }
}
