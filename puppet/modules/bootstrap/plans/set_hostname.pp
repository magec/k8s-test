plan bootstrap::set_hostname(
  TargetSpec $nodes,
  String $desired_domain = 'magec.es',
) {

  $target = get_targets($nodes)
  get_targets($nodes).each |$target| {
    add_facts($target, { 'target_hostname' => "${target}.${desired_domain}" })
  }

  run_plan('bootstrap::wait_for_update', $nodes)
  run_command('/usr/bin/apt-get update', $nodes)
  apply_prep($nodes)

  # # Compile the manifest block into a catalog
  apply($nodes) {

    File {
      ensure => 'file',
      mode   => '0644',
      owner  => 'root',
    }

    $desired_hostname = $target_hostname.split('[.]')[0]
    $domain_name = $target_hostname.split('[.]')[1,-1].join('.')

    exec { "/bin/hostname ${desired_hostname}": }

    file { '/etc/hostname':
      content => $desired_hostname,
    }

    file { '/etc/hosts':
      content => template("bootstrap/etc/hosts.erb")
    }

  }

}
