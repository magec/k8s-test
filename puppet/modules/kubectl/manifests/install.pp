class kubectl::install {

  archive { '/usr/bin/kubectl':
    source => "https://storage.googleapis.com/kubernetes-release/release/v1.18.6/bin/linux/amd64/kubectl",
    user   => 'root',
    group  => 'root',
  }

  file { '/usr/bin/kubectl':
    mode => '0755',
  }

}
