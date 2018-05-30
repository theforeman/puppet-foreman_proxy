# Changelog

## [7.2.1](https://github.com/theforeman/puppet-foreman_proxy/tree/7.2.1) (2018-05-30)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/7.2.0...7.2.1)

**Merged pull requests:**

- Allow theforeman/puppet 9.x [\#430](https://github.com/theforeman/puppet-foreman_proxy/pull/430) ([ekohl](https://github.com/ekohl))

## [7.2.0](https://github.com/theforeman/puppet-foreman_proxy/tree/7.2.0) (2018-05-29)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/7.1.0...7.2.0)

**Implemented enhancements:**

- Updated grub.cfg with explanation [\#426](https://github.com/theforeman/puppet-foreman_proxy/pull/426) ([lzap](https://github.com/lzap))
- Configure ansible reporting callback [\#424](https://github.com/theforeman/puppet-foreman_proxy/pull/424) ([ekohl](https://github.com/ekohl))
- Add acceptance tests [\#423](https://github.com/theforeman/puppet-foreman_proxy/pull/423) ([ekohl](https://github.com/ekohl))
- Add dhcp options to allow overrides [\#422](https://github.com/theforeman/puppet-foreman_proxy/pull/422) ([lukealex](https://github.com/lukealex))
- Listen on IPv6 on EL7 [\#421](https://github.com/theforeman/puppet-foreman_proxy/pull/421) ([ekohl](https://github.com/ekohl))
- Fixes [\#22862](https://projects.theforeman.org/issues/22862) - add async\_ssh param [\#418](https://github.com/theforeman/puppet-foreman_proxy/pull/418) ([chris1984](https://github.com/chris1984))
- Fixes [\#22845](https://projects.theforeman.org/issues/22845) - Install python-requests with Ansible [\#417](https://github.com/theforeman/puppet-foreman_proxy/pull/417) ([dLobatog](https://github.com/dLobatog))
- Fixes [\#22842](https://projects.theforeman.org/issues/22842) - Create .ansible.cfg in /etc/foreman-proxy [\#415](https://github.com/theforeman/puppet-foreman_proxy/pull/415) ([dLobatog](https://github.com/dLobatog))
- attempt a more accurate DNS/DHCP default interface [\#412](https://github.com/theforeman/puppet-foreman_proxy/pull/412) ([sean797](https://github.com/sean797))

**Fixed bugs:**

- Fix the instructions for puppet kick [\#427](https://github.com/theforeman/puppet-foreman_proxy/pull/427) ([swadeley](https://github.com/swadeley))

**Merged pull requests:**

- Pin facterdb to 0.5.0 [\#420](https://github.com/theforeman/puppet-foreman_proxy/pull/420) ([ekohl](https://github.com/ekohl))
- Rewrite PowerDNS support as an example [\#419](https://github.com/theforeman/puppet-foreman_proxy/pull/419) ([ekohl](https://github.com/ekohl))
- Fix the documentation for the infoblox DHCP plugin [\#414](https://github.com/theforeman/puppet-foreman_proxy/pull/414) ([ekohl](https://github.com/ekohl))

## [7.1.0](https://github.com/theforeman/puppet-foreman_proxy/tree/7.1.0) (2018-02-28)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/7.0.0...7.1.0)

**Implemented enhancements:**

- Fixes [\#22479](https://projects.theforeman.org/issues/22479) - Handle remote directory with undefined parent [\#410](https://github.com/theforeman/puppet-foreman_proxy/pull/410) ([ekohl](https://github.com/ekohl))
- Refs [\#22513](https://projects.theforeman.org/issues/22513) - Expose the dynflow file limit [\#409](https://github.com/theforeman/puppet-foreman_proxy/pull/409) ([chris1984](https://github.com/chris1984))

## [7.0.0](https://github.com/theforeman/puppet-foreman_proxy/tree/7.0.0) (2018-01-25)
[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/6.0.3...7.0.0)

**Breaking changes:**

- Remove the configure\_openscap\_repo parameter [\#403](https://github.com/theforeman/puppet-foreman_proxy/pull/403) ([ekohl](https://github.com/ekohl))
- Use puppet4 functions-api [\#402](https://github.com/theforeman/puppet-foreman_proxy/pull/402) ([juliantodt](https://github.com/juliantodt))
- Use modern defaults and document compatibility [\#401](https://github.com/theforeman/puppet-foreman_proxy/pull/401) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Allow foreman 9.x and tftp 4.x [\#406](https://github.com/theforeman/puppet-foreman_proxy/pull/406) ([ekohl](https://github.com/ekohl))
- Support tls\_disabled\_versions for dynflow core [\#404](https://github.com/theforeman/puppet-foreman_proxy/pull/404) ([stbenjam](https://github.com/stbenjam))
- Add support for additional DHCP listen interfaces [\#399](https://github.com/theforeman/puppet-foreman_proxy/pull/399) ([antaflos](https://github.com/antaflos))
- refs [\#21350](https://projects.theforeman.org/issues/21350) - installer support for disable\_tls\_versions [\#397](https://github.com/theforeman/puppet-foreman_proxy/pull/397) ([stbenjam](https://github.com/stbenjam))
- refs [\#4917](https://projects.theforeman.org/issues/4917) - add realm ad plugin support [\#396](https://github.com/theforeman/puppet-foreman_proxy/pull/396) ([timogoebel](https://github.com/timogoebel))
- Use ensure\_resource for sudoers.d [\#391](https://github.com/theforeman/puppet-foreman_proxy/pull/391) ([ekohl](https://github.com/ekohl))
- remove EOL OSes, add new ones [\#387](https://github.com/theforeman/puppet-foreman_proxy/pull/387) ([mmoll](https://github.com/mmoll))

**Fixed bugs:**

- Refs [\#20542](https://projects.theforeman.org/issues/20542) - correct link to cipher suite names [\#394](https://github.com/theforeman/puppet-foreman_proxy/pull/394) ([tbrisker](https://github.com/tbrisker))
- Fixes [\#21943](https://projects.theforeman.org/issues/21943) - Renamed netboot packages for F27 [\#393](https://github.com/theforeman/puppet-foreman_proxy/pull/393) ([ShimShtein](https://github.com/ShimShtein))
- Fixes [\#21419](https://projects.theforeman.org/issues/21419) - Fix DHCP directory ACL [\#386](https://github.com/theforeman/puppet-foreman_proxy/pull/386) ([ekohl](https://github.com/ekohl))
- Use the correct variables when checking [\#385](https://github.com/theforeman/puppet-foreman_proxy/pull/385) ([ekohl](https://github.com/ekohl))

## 6.0.3

* New or changed parameters:
    * Add `$tftp_replace_grub2_cfg` parameter to disable replace of grub2.cfg
* Other changes and fixes:
    * Bump allowed version of puppet-extlib to 3.0.0
    * Stop enabling the openscap repo
    * Introduce a `foreman_proxy::tftp::netboot` class
    * Work around broken grub 2 on EL 7.4 (#21006)
    * Set ACLs on DHCP directories (#20683)

## 6.0.2
* Fix TFTP grub_packages for RHEL 7.4+

## 6.0.1
* Add support for REX kerberos auth
* use in-memory sqlite in smart proxy dynflow

## 6.0.0
* Drop Puppet 3 support
* New or changed parameters:
    * Add `$autosignfile` for 1.16+ puppetca proxies and `$use_autosignfile` to be able to still use this module
      with older proxy versions.
    * Add `$dhcp_node_type` and `$dhcp_peer_address` for configuring DHCP failover. The behaviour can be configured
      further with advanced parameters, documented in the class docblock.
* New or changed parameters on smart proxy plugin classes:
    * Add `$ssl_disabled_ciphers` to the foreman_proxy::plugin::dynflow class.
    * Add `$collect_status` to the foreman_proxy::plugin::monitoring class.
* Other changes and fixes:
    * Set foreman_smartproxy features for built-in and plugin modules. This verifies the proxy has correctly
      registered with all the desired features.
* Compatibility warnings:
    * On Smart Proxy 1.16+ with puppetca support, `$use_autosignfile` needs to be set to `true` and `$autosignfile` to
      the full path of the `autosign.conf` file.

## 5.1.0
* New or changed parameters:
    * Add `$puppet_api_timeout` parameter to set the timeout in seconds when
      accessing the Puppet environment classes API
    * Add `$realm_split_config_files` to control if realm configuration files
      are split.
    * Add `$freeipa_config` for the path to the FreeIPA `default.conf`
      configuration file
    * Add `$use_sudoers` to add contents to `/etc/sudoers`. This is ignored if
      `$use_sudoersd` is true.
    * Allow `$bind_hosts` to also accept an array of interfaces
* New or changed parameters on smart proxy plugin classes:
    * Add the foreman_proxy::plugin::dhcp::remote_isc class for the Remote ISC
      DHCP plugin.
    * The PowerDNS plugin now also accepts `rest` as backend and got the
      `$rest_url` and `$rest_api_key` parameters added.
    * Add `$install_key` to the foreman_proxy::plugin::remote_execution class.
      When set to `true`, the generated SSH key is added to root's
      `authorized_keys`, which allows managing the proxy host through Remote
      Execution.
* Other changes and fixes:
    * foreman_proxy::plugin::ansible does now make sure that ansible is
      configured to use the foreman callback plugin.
    * Fix PXEGrub2 with vanilia GRUB2
    * Add dir for corrupted openscap reports
    * Better default value for `$dns_reverse`
    * Fix notification of the dynflow service on Debian
* Compatibility warnings:
    * On Smart Proxy 1.15 with realm support, `$realm_split_config_files` needs
      to be set to `true`.

## 5.0.0
* New or changed parameters:
    * Add groups parameter for additional foreman-proxy user groups
    * Add dhcp_pxeserver parameter to override DHCP next-server value (#16942)
    * Permit dns_reverse to be an array of zone names
* New or changed parameters on smart proxy plugin classes:
    * Add foreman_proxy::plugin::ansible class for the Ansible plugin
    * Add foreman_proxy::plugin::dhcp::infoblox class for Infoblox DHCP plugin
    * Add foreman_proxy::plugin::dns::infoblox class for Infoblox DNS plugin
    * Add foreman_proxy::plugin::monitoring class for monitoring plugin
    * Add foreman_proxy::plugin::omaha class for the Omaha plugin
* Other changes and fixes:
    * Add Arch Linux support
    * Change sudo puppetrun_cmd rule to be optional when no provider is set
    * Don't create TFTP directories and files when tftp_managed is false
    * Change grubx64.efi to signed copy from /boot instead of building (#16705)
    * Change parameter documentation to use Puppet 4 style typing
    * Change foreman_proxy::plugin::pulp's puppet_content_dir parameter default
      to use the $puppet_environmentpath fact
    * Fix dhcp_range default to be undef
    * Refactor puppetssh_command default values
    * Support modules dns 4.x, dhcp 3.x, foreman 7.x, puppet 7.x, tftp 2.x
* Compatibility warnings:
    * Drop support for Ruby 1.8.7

## 4.0.3
* Fix source EFI boot loader path for CentOS 6 (#289)

## 4.0.2
* Add symlink for dynflow_core settings directory to proxy (#16050)

## 4.0.1
* Remove management of remote_execution_ssh_core plugin, causing errors on some
  OSes (#287)

## 4.0.0
* New or changed parameters:
    * Add manage_puppet_group parameter to ensure the puppet group exists when
      no Puppet Server package is installed
* New or changed parameters on smart proxy plugin classes:
    * Add DB backend and PostgreSQL parameters to PowerDNS plugin class
    * Add puppet_content_dir parameter to Pulp plugin class
    * Add core parameters to Dynflow plugin class
* Other changes and fixes:
    * Support package architecture change in Remote Execution plugin classes
    * Make tftp/puppet modules optional by removing from foreman_proxy::params
    * Deploy UEFI GRUB/GRUB2 boot files to TFTP server roots
    * Change logs module to enabled by default
    * Move some plugin parameter docs to advanced sections
    * Compatible with theforeman/foreman 6.x
    * Compatible with theforeman/puppet 6.x
    * List compatibility with Fedora 24
* Compatibility warnings:
    * Remove libvirt_backend parameter (1.11 support)
    * Remove puppet_split_config_files_parameter (1.11 support)
    * Remove Debian 7 (Wheezy) and Ubuntu 12.04 (Precise) support

## 3.0.1
* Change puppetssh provider name to 'ssh' on 1.12+, and deprecate passing
  'puppetssh' when using split Puppet config files

## 3.0.0
* New or changed parameters:
    * Add dhcp_subnets parameter
    * Add dhcp_search_domains parameter (is relayed to dhcp::pool)
    * Add ensure_packages_version parameter for extra packages, can be set to
      'installed', 'present', 'latest' or 'absent'
    * Add libvirt_backend, set to 'virsh' for 1.11 compatibility
    * Add mcollective_user parameter
    * Add puppet_split_config_files parameter, set to false for 1.11
      compatibility
    * Add ssl_disabled_ciphers parameter for usage with 1.12 or later
    * Add tftp_managed parameter. If set to false, theforeman-tftp is not used
    * Rename virsh_network to libvirt_network
    * Remove autosign_location parameter, note that `#{puppetdir}/autosign.conf`
      is used in the proxy code itself for the path.
    * Remove puppet_cache_location parameter, no longer used by the smart proxy
    * Remove deprecated parameters for 1.10 and older
* New or changed parameters on smart proxy plugin classes:
    * Add contentdir, reportsdir, failed_dir and configure_openscap_repo to
      openscap class
* Other changes and fixes:
    * Use foreman::providers to install foreman_smartproxy dependencies
    * Pass ssl_ca to foreman_smartproxy for rest_v3 provider compatibility
    * Change default log level to INFO
    * Copy mboot.c32 for TFTP proxies
    * Fix ordering of Puppet server installation before proxy user (#14942)
* Compatibility warnings:
    * Removed support for Smart Proxy 1.10 and older, 1.11+ is required
    * Change puppetrun and puppetrun_listen_on parameters to puppet and
      puppet_listen_on respectively
    * 1.11 users must set `puppet_split_config_files => false` with Puppet

## 2.5.0
* New or changed parameters:
    * Add dhcp_split_config_files parameter, set to false for 1.10 or prior
      compatibility
    * Add dhcp_provider parameter to replace dhcp_vendor (deprecated)
    * Add logs, logs_listen_on parameters to manage new logs smart proxy module
    * Add log_buffer, log_buffer_errors parameters
    * Add tftp_manage_wget parameter to disable wget installation
* New classes to install smart proxy plugins:
    * foreman_proxy::plugin::discovery to install Discovery support
* New or changed parameters on smart proxy plugin classes:
    * Warning: removed ssh_user parameter from remote_execution plugin, the user
      is controlled from the Foreman plugin
    * Add local_working_dir, remote_working_dir parameters to remote_execution
      plugin
    * Add version parameter to openscap plugin
    * Add pulp_dir, pulp_content_dir, mongodb_dir parameters to pulp plugin
    * Add database_path, console_auth parameters to dynflow plugin
* Other changes and fixes:
    * Support Puppet 3.0 minimum
    * Support Fedora 21, remove Debian 6 (Squeeze), add Ubuntu 16.04
    * Create TFTP directories for ZTP and POAP files (#13024)
    * Use lower case FQDN to access Puppet SSL certificates (#8389)
    * Fix Puppet SSL directory under Puppet 4
    * Fix proxy registration URL take current ssl_port parameter value
    * Fix kafo data type on generate_keys parameter (#12988)
    * Refresh log/log_level parameter documentation

## 2.4.2
* Fix path to dhcpd.conf on FreeBSD

## 2.4.1
* Fix DNS providers under 1.10 to have "dns_" prefix (#12157)
* Fix missing kafo data type on powerdns::manage_database parameter
* Test speed improvements

## 2.4.0
* New or changed parameters:
    * Add dns_split_config_files parameter, set to false for 1.9 or prior
      compatibility
    * Add dhcp_server parameter for address of the DHCP server (1.10+)
* Other changes and fixes:
    * Support and test module under Puppet 4
    * Support version 1.10 with split DNS configuration files
    * Add FreeBSD support
    * Add foreman_proxy::plugin::remote_execution::ssh and
      foreman_proxy::plugin::dynflow plugin classes
    * Add foreman_proxy::plugin::dns::powerdns plugin class
    * Pass dhcp_key_name and secret to DHCP module OMAPI parameters
    * Replace random_password/cache_data from theforeman/foreman with
      puppet/extlib

## 2.3.0
* New or changed parameters:
    * Add puppet\_use\_cache/puppet\_cache\_location parameters to control
      caching functions of the 'puppet' module
    * Add new api\_* parameters to foreman_proxy::plugin::salt for its access
      to the Salt API (#8473)
    * Add bind\_host parameter for smart proxy bind IP/host in 1.8+
    * Add salt\_puppetrun\_cmd parameter to change Salt command used for
      Puppet runs in 1.8+
    * Add dhcp\_omapi\_port parameter to control the OMAPI port used for ISC
      dhcpd management in 1.9+
* Other changes and fixes:
    * Mark support for new theforeman releases using puppetlabs/concat

## 2.2.3
* Don't configure dns_key if nsupdate_gss is used (#10436)
* Copy libutil.c32 PXELinux 6 file on Debian 8/Jessie (#10255)

## 2.2.2
* Copy ldlinux.c32 PXELinux 6 file on Debian 8/Jessie (#10255)
* Change tftp_servername parameter default to undef (#9896)

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
