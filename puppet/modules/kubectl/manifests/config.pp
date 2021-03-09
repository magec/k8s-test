define kubectl::config(
  $commands,
  $config_file = $title,
)
{
  require kube_common
  require kubectl

  $config_command = $commands.map |$command| {
    "/usr/bin/kubectl config ${command} --kubeconfig=${config_file}"
  }

  $exec_command = (["/usr/bin/rm -f ${config_file}"] + $config_command).join(' && ')
  exec { $exec_command:
    creates => $config_file,
  }

}
