class runc::install {
  archive { '/usr/bin/runc':
    source => 'https://github.com/opencontainers/runc/releases/download/v1.0.0-rc93/runc.amd64',
    user   => 'root',
    group  => 'root',
  } -> file { '/usr/bin/runc':
    mode => '0755',
  }
}
