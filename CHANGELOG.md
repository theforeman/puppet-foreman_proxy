# Changelog

## 2.2.1
* Fix template variable lookups under the future parser
* Replace private() for future parser compatibility

## 2.2.0
* New classes to install smart proxy plugins:
    * foreman_proxy::plugin::abrt to install ABRT support
    * foreman_proxy::plugin::chef to install Chef support
    * foreman_proxy::plugin::openscap to install OpenSCAP support
    * foreman_proxy::plugin::salt for Salt management support
* New or changed parameters:
    * Add http_port/ssl_port parameters to listen on both HTTP/HTTPS
      simultaneously, deprecates port parameter (#8990)
    * Add *\_listen\_on parameters to control which modules listen on HTTP and
      HTTPS ports (#8990)
    * Add dhcp_option_domain parameter to change or disable setting dhcpd
      domain name option
    * Add foreman_ssl* parameters to specify keys used to access Foreman API
      from smart proxy plugins
    * Add log_level parameter to control smart proxy logging
    * Add plugin_version parameter to change default plugin package ensure
      value, add version parameter to each plugin class
* Other features:
    * Configure templates module for reverse proxying provisioning template
      requests
    * Set :foreman_url for Foreman API location
    * Support PXELinux/TFTP installation on Debian 8 (Jessie)
    * Manage pulpnode configuration in foreman_proxy::plugin::pulp
* Other changes and fixes:
    * Only manage sudo rules if puppetca or puppetrun are enabled
    * Use puppetrun_user parameter in sudo rules
    * Override TFTP server root from tftp_root parameter
    * Improvements for Puppet 4 and future parser support
    * Fix compatibility with theforeman/dns 2.0.0
    * Fix compatibility with theforeman/puppet 3.0.0
    * Fix dependency on LSB facts (#9449)
    * Fix third party package resources to use ensure_packages
    * Fix metadata quality issues, pinning dependencies

## 2.1.0
* Add puppetssh_wait parameter (#7860)
* Fix error referencing class that may not have been evaluted

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
