plan provision_ronin::reinstall (
  TargetSpec $targets,
  String     $installr_url = 'http://repos/repos/installr/mojave.dmg',
  String     $recovery_vol = 'Relops',
  String     $install_vol  = 'Macintosh HD',
) {

  notice("Setting startup disk on ${targets}")

  # Set startup disk to relops_recovery partition then reboot and wait
  run_task('provision_ronin::switch_startup_disk', $targets, 'volume' => $recovery_vol)
  run_plan('reboot', $targets)

  run_command("/usr/bin/hdiutil mount ${installr_url}", $targets, 'Mounting installr dmg')
  run_task('provision_ronin::install_macos', $targets, 'volume' => $install_vol, 'erase' => true)
}
