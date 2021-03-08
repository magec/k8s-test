# kube_apiserver::service
class kube_apiserver::service (
)
{

  systemd::service { 'kube-apiserver':
    content => template("${module_name}/kube-apiserver.service.erb"),
  }

}

