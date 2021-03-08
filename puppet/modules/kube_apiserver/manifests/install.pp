# kube_apiserver::install
class kube_apiserver::install {
  archive { '/usr/bin/kube-apiserver':
    source => "https://storage.googleapis.com/kubernetes-release/release/v1.18.6/bin/linux/amd64/kube-apiserver",
    user   => 'root',
    group  => 'root',
  }

  file { '/usr/bin/kube-apiserver':
    mode => '0755',
  }
}
