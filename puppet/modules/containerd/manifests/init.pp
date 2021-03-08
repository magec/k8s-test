# containerd
class containerd(
)
{

  class  {"${module_name}::install":
  } -> class  {"${module_name}::config":
  } ~> class {"${module_name}::service":
  }

  contain("${module_name}::install")
  contain("${module_name}::config")
  contain("${module_name}::service")

}
