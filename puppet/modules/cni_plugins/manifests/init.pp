# cni_plugins
class cni_plugins {

  class  {"${module_name}::install":
  } -> class  {"${module_name}::config":
  }

  contain("${module_name}::install")
  contain("${module_name}::config")

}
