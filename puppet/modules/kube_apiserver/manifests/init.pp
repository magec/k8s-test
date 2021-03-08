# kube_apiserver
class kube_apiserver(
)
{

  require kube_common

  class  {"${module_name}::install":
  } -> class  {"${module_name}::config":
  } ~> class {"${module_name}::service":
  }

  contain("${module_name}::install")
  contain("${module_name}::config")
  contain("${module_name}::service")

}
