define systemd::service(
  $service_name = $name,
  $content,
  $enable = true,
  $ensure = 'running',
)
{

  systemd::file { "/lib/systemd/system/${service_name}.service":
    content => $content,
  } ~> service { $service_name:
    provider => 'systemd',
    ensure   => $ensure,
    enable   => $enable,
    require  => File["/lib/systemd/system/${service_name}.service"],
  }

}
