# Puppet module for managing the Foreman Smart Proxy

Installs and configures the Foreman Smart Proxy and services that it can
interact with, e.g. DNS, DHCP and Puppet and TFTP.

Part of the Foreman installer: http://github.com/theforeman/foreman-installer

## PowerDNS support

To use the PowerDNS plugin, the following variables need to be set on the main
`foreman_proxy` class.

    $dns          => true
    $dns_managed  => false
    $dns_provider => 'dns_powerdns'

Then you also need to include `foreman_proxy::plugin::dns::powerdns`.

The powerdns plugin can optionally manage the database. If that's used, then
the puppetlabs-mysql module must be added to the modulepath, otherwise it's not
required.

## Compatibility

This module only supports Smart Proxy 1.6 or higher as of version 2.0, as the
configuration layout changed significantly.

To configure older versions of the Smart Proxy (1.5 or older), use an older
version of this module (1.x).

Since version 1.10 the DNS configuration files are split. If you wish to use
prior versions with DNS, then you must set `dns_split_config_files` to `false`.

# Contributing

* Fork the project
* Commit and push until you are happy with your contribution
* Send a pull request with a description of your changes

# More info

See http://theforeman.org or at #theforeman irc channel on freenode

Copyright (c) 2010-2013 Ohad Levy and their respective owners

Except where specified in provided modules, this program and entire
repository is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
