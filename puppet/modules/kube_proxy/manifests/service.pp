# kube_proxy::service
class kube_proxy::service (
)
{

  systemd::service { 'kube-proxy':
    content => template("${module_name}/kube-proxy.service.erb"),
  }

}

