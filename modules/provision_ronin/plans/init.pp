plan provision_ronin (
  TargetSpec $nodes,
  String $host_name,
  String $domain_name,
  String $role,
  String $dc,
  String $vault_approle_id,
  String $vault_approle_secret,
  String $xcode_cmdline_tools_source_url      = lookup('provision_ronin::xcode_cmdline_tools_source_url'),
  String $vault_addr_url      = lookup('provision_ronin::vault_addr_url'),
  Hash   $vault_source        = lookup('provision_ronin::vault_source'),
  String $puppet_repo_url     = lookup('provision_ronin::puppet_repo_url'),
  String $puppet_repo_branch  = lookup('provision_ronin::puppet_repo_branch'),
  String $puppet_run_interval = lookup('provision_ronin::puppet_run_interval'),
  String $puppet_run_strategy = lookup('provision_ronin::puppet_run_strategy'),
) {


  # Install puppet on the target and gather facts
  $nodes.apply_prep

  notice("Deploying on ${nodes}")

  # Compile the manifest block into a catalog
  $results = apply($nodes) {

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

    class { 'provision_ronin::vault_agent':
        vault_approle_id     => $vault_approle_id,
        vault_approle_secret => $vault_approle_secret,
        vault_addr_url       => $vault_addr_url,
        vault_source         => $vault_source,
    }

    class { 'provision_ronin::puppet_apply':
        role                           => $role,
        dc                             => $dc,
        xcode_cmdline_tools_source_url => $xcode_cmdline_tools_source_url,
        puppet_repo_url                => $puppet_repo_url,
        puppet_repo_branch             => $puppet_repo_branch,
        puppet_run_interval            => $puppet_run_interval,
        puppet_run_strategy            => $puppet_run_strategy,
    }

  }

  $results.each |$result| {
    notice($result.report)
  }
  return run_task('provision_ronin::set_hostname_macos', $nodes, hostname => $host_name, domain => $domain_name)

 # run_plan('reboot', $nodes, reconnect_timeout => 300)

}
