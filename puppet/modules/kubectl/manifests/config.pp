define kubectl::config(
  $commands,
  $config_file = $title,
)
{
  require kube_common
  require kubectl

  $exec_command = $commands.map |$command| {
    "/usr/bin/kubectl config ${command} --kubeconfig=${config_file}"
  }

  exec { ["/usr/bin/rm -f ${config_file}"] + $exec_command:
    creates => $config_file,
  }

}
