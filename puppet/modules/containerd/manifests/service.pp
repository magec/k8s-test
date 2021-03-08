# containerd::service
class containerd::service (
)
{

  systemd::service { 'containerd':
    content => template("${module_name}/containerd.service.erb"),
  }

}

