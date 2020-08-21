class provision_ronin::puppet_apply (
  String $role,
  String $dc,
  String $xcode_cmdline_tools_source_url = lookup('provision_ronin::xcode_cmdline_tools_source_url'),
  String $puppet_repo_url                = lookup('provision_ronin::puppet_repo_url'),
  String $puppet_repo_branch             = lookup('provision_ronin::puppet_repo_branch'),
  String $puppet_run_interval            = lookup('provision_ronin::puppet_run_interval'),
  String $puppet_run_strategy            = lookup('provision_ronin::puppet_run_strategy'),
) {

   case $puppet_run_strategy {
        'periodic': {
            $puppet_service = true
            $puppet_timer = true
        }
        'at_boot': {
            $puppet_service = true
            $puppet_timer = false
        }
        # default to never
        default: {
            $puppet_service = false
            $puppet_timer = false
        }
    }

    file {
        # Create directory for puppet apply working dir
        [ '/etc/puppet',
          '/etc/puppet/environments',
          '/etc/puppet/environments/production',
          '/etc/puppet/environments/production/code' ]:
            ensure  => directory;
    }

    case $facts['os']['name'] {
        'Darwin': {
            # Provides git
            package { 'xcode_command_line_tools':
                ensure   => installed,
                provider => pkgdmg,
                source   => $xcode_cmdline_tools_source_url,
                before   => Vcsrepo['/etc/puppet/environments/production/code'],
            }

        }
        'Ubuntu': {
            package { 'git':
                ensure => present,
                before => Vcsrepo['/etc/puppet/environments/production/code'],
            }
        }
        default: { fail("${facts['os']['name']} is not supported") }
    }

    # Execute an initial clone and setup of the prodution puppet repo this node will be using
    vcsrepo { '/etc/puppet/environments/production/code':
        ensure   => latest,
        provider => git,
        source   => $puppet_repo_url,
        revision => $puppet_repo_branch,
    }

    file {

        # Write nodes puppet role to disk
        '/etc/puppet_role':
            ensure  => file,
            content => "${role}\n";

        # Setup external facter facts specific to this node
        '/etc/facter':
            ensure  => directory;
        '/etc/facter/facts.d/':
            ensure  => directory;
        '/etc/facter/facts.d/kv.yaml':
            ensure  => file,
            content => template('provision_ronin/kv.yaml.epp');
    }

    case $facts['os']['name'] {
        'Darwin': {
        }
        'Ubuntu': {
            file {

                # Setup puppet defaults file
                '/etc/default/puppet-apply':
                    ensure  => file,
                    content => template('provision_ronin/puppet-apply.defaults.epp');

                # Create the puppet-apply systemd service
                '/etc/systemd/system/puppet-apply.service':
                    ensure  => file,
                    content => template('provision_ronin/puppet-apply.service.epp');

                # Create the puppet-apply systemd service timer
                '/etc/systemd/system/puppet-apply.timer':
                    ensure  => file,
                    content => template('provision_ronin/puppet-apply.timer.epp');
            }

            # Ensure puppet-apply service is enabled but don't start it
            service { 'puppet-apply.service':
                enable => $puppet_service,
            }

            # Ensure puppet-apply timer is enabled and running
            service { 'puppet-apply.timer':
                ensure => $puppet_timer,
                enable => $puppet_timer,
            }
        }
        default: { fail("${facts['os']['name']} is not supported") }
    }
}
