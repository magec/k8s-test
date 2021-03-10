plan bootstrap::wait_for_update(
  TargetSpec $nodes,
) {

  # Wait apt-update to finish first
  run_plan('bootstrap::wait_until_available', $nodes)
  run_command("/bin/bash -c \"while ! /bin/systemctl status apt-daily-upgrade --no-pager|grep SUCCESS; do /bin/systemctl start apt-daily-upgrade; sleep 1 ; done\"", $nodes)

}
