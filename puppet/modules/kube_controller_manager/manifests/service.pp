# kube_controller_manager::service
class kube_controller_manager::service (
)
{

  systemd::service { 'kube-controller-manager':
    content => template("${module_name}/kube-controller-manager.service.erb"),
  }

}

