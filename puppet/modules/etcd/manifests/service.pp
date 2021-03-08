# etcd::service
class etcd::service (
)
{

  systemd::service { 'etcd':
    content => template("${module_name}/etcd.service.erb"),
  }

}

