# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

class roles_profiles::profiles::puppet {

    case $::operatingsystem {
        'Darwin': {
            $puppet_run_strategy = lookup('puppet_run_strategy', undef, undef, undef)
            case $puppet_run_strategy {
                'atboot': {
                    class { 'puppet::atboot':
                        telegraf_user     => lookup('telegraf.user'),
                        telegraf_password => lookup('telegraf.password'),
                        meta_data         => lookup('worker_metadata')
                    }
                }
                'cron': {
                    # TODO
                }
                'never', default: {
                    # TODO: ensure puppet doesn't run
                }
            }
        }
        default: {
            fail("${::operatingsystem} not supported")
        }
    }


}
