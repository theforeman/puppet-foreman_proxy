# Puppet module for managing the Foreman Smart Proxy

Installs and configures the Foreman Smart Proxy and services that it can
interact with, e.g. DNS, DHCP and Puppet and TFTP.

Part of the Foreman installer: <https://github.com/theforeman/foreman-installer>

## Compatibility

| Module version | Proxy versions | Notes                                           |
|----------------|----------------|-------------------------------------------------|
| 5.x            | 1.16 and newer | See compatibility notes here for 1.16-1.18      |
| 4.x            | 1.12 - 1.17    | See compatibility notes in its README for 1.15+ |
| 3.x            | 1.11           |                                                 |
| 2.x            | 1.5 - 1.10     |                                                 |
| 1.x            | 1.4 and older  |                                                 |

### Compatibility notes for Smart Proxy < 1.18

On Smart Proxy 1.16, 1.17 & 1.18, also set

```puppet
puppetca_modular => false,
```

to ensure that it only uses the `puppetca.yml` configuration not the provider settings files.


## Examples

### Minimal setup for Puppet/PuppetCA Smart Proxy

```puppet
class{'::foreman_proxy':
  puppet   => true,
  puppetca => true,
  tftp     => false,
  dhcp     => false,
  dns      => false,
  bmc      => false,
  realm    => false,
}
```

### PowerDNS support

To use the PowerDNS plugin, the following variables need to be set on the main
`foreman_proxy` class.

```puppet
class{'::foreman_proxy':
  dns          => true,
  dns_managed  => false,
  dns_provider => 'powerdns',
}
```

Then you also need to include `foreman_proxy::plugin::dns::powerdns`.

The powerdns plugin can optionally manage the database. If that's used, then
the puppetlabs-mysql module must be added to the modulepath, otherwise it's not
required.

## Contributing

* Fork the project
* Commit and push until you are happy with your contribution
* Send a pull request with a description of your changes

## More info

See <https://theforeman.org> or at #theforeman irc channel on freenode

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
along with this program.  If not, see <https://www.gnu.org/licenses/>.
