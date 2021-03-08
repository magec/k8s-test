plan bootstrap::set_locale(
  TargetSpec $nodes,
) {

  run_command("locale-gen en_US.UTF-8", $nodes)
  run_command("update-locale LC_ALL=en_US.UTF-8", $nodes)

}
