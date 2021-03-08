plan bootstrap::apt_update(
  TargetSpec $nodes,
) {

  run_plan('bootstrap::wait_for_update', $nodes)
  run_command('/usr/bin/apt-get update', $nodes)

}
