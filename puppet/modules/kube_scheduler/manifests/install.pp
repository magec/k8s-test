# kube_scheduler::install
class kube_scheduler::install {
  archive { '/usr/bin/kube-scheduler':
    source => "https://storage.googleapis.com/kubernetes-release/release/v1.18.6/bin/linux/amd64/kube-scheduler",
    user   => 'root',
    group  => 'root',
  }

  file { '/usr/bin/kube-scheduler':
    mode => '0755',
  }

}
