plan bootstrap::wait_until_available(
  TargetSpec $targets,
) {

  wait_until_available($targets, wait_time => 100, retry_interval => 1)

}
