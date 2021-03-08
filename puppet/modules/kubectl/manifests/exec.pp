define kubectl::exec(
  $command = $title,
  $refreshonly = true,
)
{
  exec { "/usr/bin/kubectl ${command}":
    refreshonly => true,
  }
}
