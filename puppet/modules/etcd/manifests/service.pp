# etcd::service
class etcd::service (
)
{

  $info = $network_info
  systemd::service { 'etcd':
    content => template("${module_name}/etcd.service.erb"),
  }

}

