# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

class fw::profiles::dep_signing_from_anywhere {
    include fw::networks

    fw::rules { 'allow_dep_signing_from_anywhere':
        sources =>  $::fw::networks::everywhere,
        app     => 'dep_signing'
    }
}
