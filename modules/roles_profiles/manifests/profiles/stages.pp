# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

class roles_profiles::profiles::stages {

    stage {

        # network:
        # This stage should handle any network related configurations for some
        # specific cases (like AWS)
        'network':
            before => Stage['packagesetup'];

        # packagesetup:
        # This stage should handle any preliminaries required for package
        # installations, so that subsequent package installations do not need to
        # require them explicitly.
        'packagesetup':
            before => Stage['users'];

        'users':
            before => Stage['main'];

        # Firewall should be the last stage to prevent network disconnctions
        'firewall':
            subscribe => Stage['main'];
    }
}
