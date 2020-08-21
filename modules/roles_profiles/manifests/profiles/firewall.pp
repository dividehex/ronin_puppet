# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

class roles_profiles::profiles::firewall {

    case $::operatingsystem {
        'Windows': {
            include win_firewall::allow_ping
            if $facts['custom_win_location'] == 'aws' {
                if $facts['custom_win_firewall_status'] == 'running' {
                    include win_firewall::disable_firewall
                }
            }
            # Bug List
            # https://bugzilla.mozilla.org/show_bug.cgi?id=1510834
            # AWS disable firewall
            # https://bugzilla.mozilla.org/show_bug.cgi?id=1562038
            # https://bugzilla.mozilla.org/show_bug.cgi?id=1358301
        }
        'Darwin': {
            $fw_role = lookup('firewall_role', undef, undef, undef)
            notice("fw_role: ${fw_role}")
            if $fw_role {
                class { "::fw::roles::${fw_role}": }
            }
        }
        default: {
            fail("${::operatingsystem} not supported")
        }
    }
}
