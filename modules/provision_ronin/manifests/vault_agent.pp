class provision_ronin::vault_agent (
  String $vault_approle_id,
  String $vault_approle_secret,
  String $vault_addr_url      = lookup('provision_ronin::vault_addr_url'),
  Hash   $vault_source        = lookup('provision_ronin::vault_source'),
) {

    $vault_source_url = $vault_source[$facts['kernel']]['url']
    $vault_sha256     = $vault_source[$facts['kernel']]['sha256']

    $vault_filename = split($vault_source_url,'/')[-1]

    file {
        # Create approle id and secret file for vault agent to consume
        '/etc/vault_approle_id':
            ensure  => file,
            mode    => '0600',
            content => "${vault_approle_id}\n";
        '/etc/vault_approle_secret':
            ensure  => file,
            mode    => '0600',
            content => "${vault_approle_secret}\n";

        # Create vault agent config
        '/etc/vault-agent-config.hcl':
            ensure  => file,
            mode    => '0600',
            content => template('provision_ronin/vault-agent-config.hcl.epp');

        [ '/usr/local',
          '/usr/local/bin' ]:
            ensure  => directory;

        # Install vault binary
        "/usr/local/bin/${vault_filename}":
            ensure         => file,
            mode           => '0755',
            source         => $vault_source_url,
            checksum       => sha256,
            checksum_value => $vault_sha256;

        # Create link to vault binary
        '/usr/local/bin/vault':
            ensure => link,
            target => "/usr/local/bin/${vault_filename}";
    }


    case $facts['os']['name'] {
        'Darwin': {
            # Launchd vault-agent service
            file {
                '/Library/LaunchDaemons/io.vaultproject.vault-agent.plist':
                    ensure => file,
                    source => 'puppet:///modules/provision_ronin/vault-agent.plist',
                    notify => Service['vault-agent'],
            }
        }
        'Ubuntu': {
            # Setup systemd vault-agent service
            file {
                '/etc/systemd/system/vault-agent.service':
                    ensure => file,
                    source => 'puppet:///modules/provision_ronin/vault-agent.service';

                # Set global VAULT_ADDR path to localhost so calls to vault will point to the local vault agent
                '/etc/profile.d/vault_env.sh':
                    ensure  => file,
                    content => 'export VAULT_ADDR=http://127.0.0.1:8200\n';
            }
        }
        default: { fail("${facts['os']['name']} is not supported") }
    }

    # Ensure vault-agent service is enabled and running
    service { 'vault-agent':
        ensure => 'running',
        enable => 'true',
    }
}
