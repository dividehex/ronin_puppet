plan provision_ronin::setup_puppet_env (
  TargetSpec $targets = 'localhost',
  Boolean    $noop = true,
) {

    $targets.apply_prep

    apply($targets, _catch_errors => false, _noop => $noop) {
        package { 'vault-puppetpath-gem':
            ensure   => 'present',
            name     => 'vault',
            provider => 'puppet_gem',
        }

        package { 'debouncer-puppetpath-gem':
            ensure   => 'present',
            name     => 'debouncer',
            provider => 'puppet_gem',
        }

        package { 'r10k-puppetpath-gem':
            ensure   => 'present',
            name     => 'r10k',
            provider => 'puppet_gem',
        }
    }

}
