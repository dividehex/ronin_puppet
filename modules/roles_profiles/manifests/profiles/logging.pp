# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

class roles_profiles::profiles::logging {


    case $::operatingsystem {
        'Windows': {

            $location        = $facts['custom_win_location']
            $programfilesx86 = $facts['custom_win_programfilesx86']
            if ($facts['custom_win_location'] == 'datacenter') {
                $conf_file = epp('win_nxlog/nxlog.conf.epp')
            } else {
                $conf_file = file('win_nxlog/non_datacenter_nxlog.conf')
            }

            class { 'win_nxlog':
                nxlog_dir => "${programfilesx86}\\nxlog",
                location  => $location,
                conf_file => $conf_file,
            }
            # Bug List
            # https://bugzilla.mozilla.org/show_bug.cgi?id=1520947
        }
        'Darwin': {
            class { 'fluentd':
                worker_type   => lookup('gw.worker_type'),
                syslog_host   => lookup('log_aggregator'),
                syslog_port   => 514,
                mac_log_level => 'default',
            }
        }
        default: {
            fail("${::operatingsystem} not supported")
        }
    }
}
