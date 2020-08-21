# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

class roles_profiles::profiles::generic_worker {

    contain roles_profiles::profiles::cltbld_user

    $worker_type  = lookup('gw.worker_type')
    $worker_group = lookup('gw.worker_group')
    $provioner_id = lookup('gw.provisioner_id')
    $worker_id    = lookup('gw.worker_id')

    case $::operatingsystem {
        'Darwin': {

            $taskcluster_client_id     = lookup('generic_worker_secrets.taskcluster_client_id')
            $taskcluster_access_token  = lookup('generic_worker_secrets.taskcluster_access_token')
            $livelog_secret            = lookup('generic_worker_secrets.livelog_secret')
            $quarantine_client_id      = lookup('generic_worker_secrets.quarantine_client_id')
            $quarantine_access_token   = lookup('generic_worker_secrets.quarantine_access_token')
            $bugzilla_api_key          = lookup('generic_worker_secrets.bugzilla_api_key')
            $generic_worker_version    = lookup('gw.generic_worker_version')
            $generic_worker_sha256     = lookup('gw.generic_worker_sha256')
            $taskcluster_proxy_version = lookup('gw.taskcluster_proxy_version')
            $taskcluster_proxy_sha256  = lookup('gw.taskcluster_proxy_sha256')
            $quarantine_worker_version = lookup('gw.quarantine_worker_version')
            $quarantine_worker_sha256  = lookup('gw.quarantine_worker_sha256')

            class { 'generic_worker':
                taskcluster_client_id     => $taskcluster_client_id,
                taskcluster_access_token  => $taskcluster_access_token,
                livelog_secret            => $livelog_secret,
                worker_group              => $worker_group,
                worker_type               => $worker_type,
                quarantine_client_id      => $quarantine_client_id,
                quarantine_access_token   => $quarantine_access_token,
                bugzilla_api_key          => $bugzilla_api_key,
                generic_worker_version    => $generic_worker_version,
                generic_worker_sha256     => $generic_worker_sha256,
                taskcluster_proxy_version => $taskcluster_proxy_version,
                taskcluster_proxy_sha256  => $taskcluster_proxy_sha256,
                quarantine_worker_version => $quarantine_worker_version,
                quarantine_worker_sha256  => $quarantine_worker_sha256,
                user                      => 'cltbld',
                user_homedir              => '/Users/cltbld',
            }

            include dirs::tools

            include roles_profiles::profiles::disable_chrome_updater

            file { '/tools/tooltool.py':
                ensure  => 'link',
                target  => '/usr/local/bin/tooltool.py',
                require => Class['packages::tooltool'],
            }

            contain mercurial::system_hgrc
            include mercurial::ext::robustcheckout

            python2::user_pip_conf { 'cltbld_user_pip_conf':
                user  => 'cltbld',
                group => 'staff',
            }

            file {
                '/tools/python':
                    ensure  => 'link',
                    target  => '/usr/local/bin/python2',
                    require => Class['packages::python2'];

                '/tools/python2':
                    ensure  => link,
                    target  => '/usr/local/bin/python2',
                    require => Class['packages::python2'];
            }

            file { '/tools/python3':
                    ensure  => 'link',
                    target  => '/usr/local/bin/python3',
                    require => Class['packages::python3'],
            }

        }
        default: {
            fail("${::operatingsystem} not supported")
        }
    }
}
