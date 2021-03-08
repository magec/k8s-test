# kubelet::install
class kubelet::install {
  archive { '/usr/bin/kubelet':
    source => 'https://storage.googleapis.com/kubernetes-release/release/v1.18.6/bin/linux/amd64/kubelet',
    user   => 'root',
    group  => 'root',
  }

  file { '/usr/bin/kubelet':
    mode => '0755',
  }
}
