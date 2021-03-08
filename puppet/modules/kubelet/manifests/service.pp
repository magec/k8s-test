# kubelet::service
class kubelet::service (
)
{

  systemd::service { 'kubelet':
    content => template("${module_name}/kubelet.service.erb"),
  }

}

