# Changelog

## 2.0.2
* Set trusted_hosts default value to FQDN

## 2.0.1
* Validate IP address facts used in DHCP/DNS templates (#7263)
* Fix relationship specification for early Puppet 2.7 releases
* Fix lint issue

## 2.0.0
* Deploy configuration files for Foreman 1.6 modular smart proxy
    * Compatible with 1.6 only, use 1.x versions for 1.5 or older
* Add foreman_proxy::plugin define for installation of proxy plugins
* Add foreman_proxy::plugin::pulp class for Pulp plugin
* Ensure foreman_proxy::service is refreshed after SSL certs change
* Install apipie-bindings package for foreman_smartproxy registration
* Add $version parameter to control package version
* Update puppet.yml config file for directory environment settings
* Fix operatingsystemrelease comparison for CentOS 7
* Fix handling of alias/VLAN interface fact names
* Remove mocha test dependency
* Fix lint issues

## 1.6.1
* Fix user shell path so it's valid on Debian (#5390)

## 1.6.0
* Add parameters for all Foreman 1.4 and realm (1.5) features

## 1.5.0
* Add dns_provider parameter
* Use ensure_packages for non-core wget package
* Remove template source from header for Puppet 3.5 compatibility
* Fix missing dependency on foreman module
* Fix top-scope variable without an explicit namespace

## 1.4.0
* Add $puppetrun_provider parameter
* Fix disabling of ssl_* settings when $ssl is false
* Puppet 2.6 support deprecated
* Fix stdlib dependency for librarian-puppet
