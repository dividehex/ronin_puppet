plan provision_ronin::puppet_push (
  TargetSpec $targets,
  String     $local_repo_dir,
  String     $code_environment = 'prod',
  String     $role,
  Boolean    $debug = false,
) {

  notice("Pushing ${local_repo_dir} to ${targets}")

  # Compile the manifest block into a catalog
  run_command("rm -rf /etc/puppet/environments/${code_environment}/", $targets, 'Remove remote puppet directory')
  run_command("mkdir -p /etc/puppet/environments/${code_environment}", $targets, 'Create remote puppet directory')

  upload_file($local_repo_dir, "/etc/puppet/environments/${code_environment}/code", $targets, 'Uploading puppet working directory')
  run_command("chmod 777 /etc/puppet/environments/${code_environment}/code", $targets, 'Change mode remote puppet directory')


  if $debug { $debug_flag = '--debug'  } else { $debug_flag = ''  }
  run_command("cd /etc/puppet/environments/${code_environment}/code && PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/puppetlabs/bin LANG=en_US.UTF-8 /opt/puppetlabs/bin/puppet apply --modulepath=./modules:./r10k_modules --hiera_config=./hiera.yaml --detailed-exitcodes -e \"include roles_profiles::roles::${role}\" ${debug_flag} --trace", $targets, 'Execute remote puppet')
}
