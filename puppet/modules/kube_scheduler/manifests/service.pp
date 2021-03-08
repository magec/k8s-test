# kube_scheduler::service
class kube_scheduler::service (
)
{

  systemd::service { 'kube-scheduler':
    content => template("${module_name}/kube-scheduler.service.erb"),
  }

}

