plan provision_ronin::fire_up_gw (
  TargetSpec $nodes,
  String     $domain_name = 'macstadium-lv.relops.mozops.net',
  String     $host_name,
) {

  notice("Initiating ${nodes}")

  run_task('provision_ronin::set_hostname_macos', $nodes, hostname => $host_name, domain => $domain_name)
  run_task('provision_ronin::set_gw_worker_id', $nodes, hostname => $host_name)
}
