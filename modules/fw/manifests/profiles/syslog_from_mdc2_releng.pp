# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

class fw::profiles::syslog_from_mdc2_releng {
    include fw::networks

    fw::rules { 'allow_syslog_udp_from_mdc2_releng':
        sources =>  $::fw::networks::mdc2_releng,
        app     => 'syslog_udp'
    }
    fw::rules { 'allow_syslog_tcp_from_mdc2_releng':
        sources =>  $::fw::networks::mdc2_releng,
        app     => 'syslog_tcp'
    }
}
