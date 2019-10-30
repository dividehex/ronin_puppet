# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

class nrpe::service {

    include nrpe::settings

    case $facts['os']['name'] {
        'Darwin': {

            include packages::nrpe

            $svc_plist = '/Library/LaunchDaemons/org.nagios.nrpe.plist'
            file {
                $svc_plist:
                    content => template("${module_name}/nrpe.plist.erb");
            }

            service { 'org.nagios.nrpe':
                ensure  => running,
                enable  => true,
                require => [
                    Class['packages::nrpe'],
                    File[$svc_plist],
                ];
            }
        }
        default: {
            fail("${$facts['os']['name']} not supported")
        }
    }
}
