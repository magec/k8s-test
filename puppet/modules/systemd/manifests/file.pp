define systemd::file (
  $ensure             = file,
  $owner              = 'root',
  $mode               = '0644',
  $group              = 'root',
  $path               = $name,
  $content            = undef,
  $source             = undef,
)
{

  file { $path:
    ensure  => $ensure,
    owner   => $owner,
    mode    => $mode,
    path    => $path,
    group   => $group,
    source  => $source,
    content => $content,
  } ~> exec { "Reload systemd for ${path}":
    command     => '/bin/systemctl daemon-reload',
    refreshonly => true,
  }

}
