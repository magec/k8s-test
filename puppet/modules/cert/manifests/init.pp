# Creates certs using cfssl
define cert(
  $cn = $title,
  $hostnames,
  $path,
  $replace = false,
) {

  $cert = gen_cert($cn, $hostnames)

  file { "${path}/${title}.pem":
    ensure  => 'file',
    mode    => '0600',
    owner   => 'root',
    group   => 'root',
    replace => $replace,
    content => $cert["cert"],
  }

  file { "${path}/${title}-key.pem":
    ensure  => 'file',
    mode    => '0600',
    owner   => 'root',
    group   => 'root',
    replace => $replace,
    content => $cert["key"],
  }

}
