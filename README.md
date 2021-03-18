[![Puppet Forge](https://img.shields.io/puppetforge/v/theforeman/foreman_proxy.svg)](https://forge.puppetlabs.com/theforeman/foreman_proxy)
[![CI](https://github.com/theforeman/puppet-foreman_proxy/actions/workflows/ci.yml/badge.svg)](https://github.com/theforeman/puppet-foreman_proxy/actions/workflows/ci.yml)

# Puppet module for managing the Foreman Smart Proxy

Installs and configures the Foreman Smart Proxy and services that it can
interact with, e.g. DNS, DHCP and Puppet and TFTP.

Part of the Foreman installer: <https://github.com/theforeman/foreman-installer>

## Compatibility

| Module version | Proxy versions | Notes                                               |
|----------------|----------------|-----------------------------------------------------|
| 16.x - 17.x    | 2.3 and newer  | See compatibility notes in its README for 2.0-2.2   |
| 13.x - 15.x    | 2.0 - 2.2      |                                                     |
| 12.x           | 1.19 - 1.24    | See compatibility notes in its README for 1.19-1.22 |
| 11.x           | 1.19 - 1.23    | See compatibility notes in its README for 1.19-1.21 |
| 10.x           | 1.19 - 1.21    |                                                     |
| 5.x - 9.x      | 1.16 - 1.20    | See compatibility notes in its README for 1.16-1.18 |
| 4.x            | 1.12 - 1.17    | See compatibility notes in its README for 1.15+     |
| 3.x            | 1.11           |                                                     |
| 2.x            | 1.5 - 1.10     |                                                     |
| 1.x            | 1.4 and older  |                                                     |

16.x added support for Smart Proxy Registration feature, available in Smart Proxy 2.3 and newer.
12.x has dropped support for Puppet 3 which was officially unsupported for a while and Foreman Proxy 1.23 dropped altogether.

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

### DNS plugin support

To use the a DNS plugin, the following variables need to be set on the main `foreman_proxy` class. Be sure to correct the `dns_provider` to your actual provider.

```puppet
class { 'foreman_proxy':
  dns          => true,
  dns_provider => 'powerdns',
}
```

Then you also need to include the appropriate class, such as `foreman_proxy::plugin::dns::powerdns`.

### Remote Execution User Management

This module can also be used to manage the ssh user on
[Foreman Remote Execution](https://github.com/theforeman/foreman_remote_execution)
clients.

```puppet
include foreman_proxy::plugin::remote_execution::ssh_user
```

The class will make use of the `remote_execution_*` host parameters available
in the ENC data provided by Foreman.

It will manage the user, (by default `foreman_ssh`), install/update the ssh
keys and manage the sudo rules (using [saz/sudo](https://forge.puppet.com/saz/sudo)
if available in your environment).

### Ansible integration

The Foreman Proxy Ansible plugin installs the optional package for
[ansible-runner](https://github.com/ansible/ansible-runner) by default.
Additional repositories are enabled since this isn't present in the
repositories we depend on (base OS and EPEL). There is a parameter to disable
this behavior in which case the user is expected to ensure an `ansible-runner`
package can be installed. There is also an option to fully disable installing.
The plugin authors consider ansible-runner the preferred way to run so
disabling is discouraged.

```puppet
class { 'foreman_proxy::plugin::ansible':
  install_runner     => false, # defaults to true
  manage_runner_repo => false, # defaults to true, redundant when install_runner is false
}
```

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
