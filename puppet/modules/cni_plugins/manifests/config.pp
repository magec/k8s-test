class cni_plugins::config {

  file { ['/etc/cni/', '/etc/cni/net.d']:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/cni/net.d/10-bridge.conf':
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    content => template("${module_name}/etc/cni/net.d/10-bridge.conf.erb"),
  }

  file { '/etc/cni/net.d/99-loopback.conf':
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => "puppet:///modules/${module_name}/etc/cni/net.d/99-loopback.conf",
  }
}
