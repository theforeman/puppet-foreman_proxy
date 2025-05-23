# Changelog

## [28.1.0](https://github.com/theforeman/puppet-foreman_proxy/tree/28.1.0) (2025-05-11)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/28.0.1...28.1.0)

**Implemented enhancements:**

- Add client\_endpoint support to container\_gateway plugin [\#863](https://github.com/theforeman/puppet-foreman_proxy/pull/863) ([ehelms](https://github.com/ehelms))
- Fixes [\#38279](https://projects.theforeman.org/issues/38279) - Respect crypto-policies in mosquitto on EL [\#859](https://github.com/theforeman/puppet-foreman_proxy/pull/859) ([ekohl](https://github.com/ekohl))

## [28.0.1](https://github.com/theforeman/puppet-foreman_proxy/tree/28.0.1) (2025-03-19)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/28.0.0...28.0.1)

**Fixed bugs:**

- Fix space\_before\_arrow lint check [\#860](https://github.com/theforeman/puppet-foreman_proxy/pull/860) ([ekohl](https://github.com/ekohl))
- Fixes [\#38259](https://projects.theforeman.org/issues/38259) - Use the correct ssl\_port variable [\#857](https://github.com/theforeman/puppet-foreman_proxy/pull/857) ([ekohl](https://github.com/ekohl))

## [28.0.0](https://github.com/theforeman/puppet-foreman_proxy/tree/28.0.0) (2025-02-13)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/27.0.0...28.0.0)

**Breaking changes:**

- Drop EoL EL8 / Ubuntu 20.04 / Debian 11 support [\#853](https://github.com/theforeman/puppet-foreman_proxy/pull/853) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Allow puppet-foreman 26.0.0 [\#855](https://github.com/theforeman/puppet-foreman_proxy/pull/855) ([ehelms](https://github.com/ehelms))
- Require stdlib 9 / use namespaced functions [\#850](https://github.com/theforeman/puppet-foreman_proxy/pull/850) ([bastelfreak](https://github.com/bastelfreak))
- Add support for running on Puppet Enterprise Primary [\#848](https://github.com/theforeman/puppet-foreman_proxy/pull/848) ([bastelfreak](https://github.com/bastelfreak))
- Fixes [\#36940](https://projects.theforeman.org/issues/36940) - Add SecureBoot support for arbitrary operating systems to "Grub2 UEFI" PXE loaders [\#821](https://github.com/theforeman/puppet-foreman_proxy/pull/821) ([goarsna](https://github.com/goarsna))

**Fixed bugs:**

- Correctly spell Hdm feature name in plugin config [\#854](https://github.com/theforeman/puppet-foreman_proxy/pull/854) ([tuxmea](https://github.com/tuxmea))
- Ensure proxy register runs before puppetserver service [\#852](https://github.com/theforeman/puppet-foreman_proxy/pull/852) ([bastelfreak](https://github.com/bastelfreak))

## [27.0.0](https://github.com/theforeman/puppet-foreman_proxy/tree/27.0.0) (2024-11-04)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/26.1.0...27.0.0)

**Breaking changes:**

- stop removing ansible runner yumrepo [\#847](https://github.com/theforeman/puppet-foreman_proxy/pull/847) ([evgeni](https://github.com/evgeni))
- Fixes [\#37803](https://projects.theforeman.org/issues/37803) - Remove hardcoded ProxyCommand [\#845](https://github.com/theforeman/puppet-foreman_proxy/pull/845) ([adamlazik1](https://github.com/adamlazik1))

## [26.1.0](https://github.com/theforeman/puppet-foreman_proxy/tree/26.1.0) (2024-08-14)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/26.0.0...26.1.0)

**Implemented enhancements:**

- Refs [\#37707](https://projects.theforeman.org/issues/37707) - Support purging container\_gateway [\#843](https://github.com/theforeman/puppet-foreman_proxy/pull/843) ([ekohl](https://github.com/ekohl))
- Refs [\#37604](https://projects.theforeman.org/issues/37604) - Validate DNS forwarders values [\#842](https://github.com/theforeman/puppet-foreman_proxy/pull/842) ([ekohl](https://github.com/ekohl))
- Add AlmaLinux 9 support [\#840](https://github.com/theforeman/puppet-foreman_proxy/pull/840) ([archanaserver](https://github.com/archanaserver))

## [26.0.0](https://github.com/theforeman/puppet-foreman_proxy/tree/26.0.0) (2024-05-21)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/25.3.0...26.0.0)

**Breaking changes:**

- Fixes [\#37325](https://projects.theforeman.org/issues/37325) - make postgres the container gateway default DB [\#835](https://github.com/theforeman/puppet-foreman_proxy/pull/835) ([ianballou](https://github.com/ianballou))

**Implemented enhancements:**

- Mark compatible with theforeman/foreman 25.x [\#836](https://github.com/theforeman/puppet-foreman_proxy/pull/836) ([ekohl](https://github.com/ekohl))
- Add support for Debian 12 [\#834](https://github.com/theforeman/puppet-foreman_proxy/pull/834) ([evgeni](https://github.com/evgeni))
- Add support for Ubuntu 22.04 [\#832](https://github.com/theforeman/puppet-foreman_proxy/pull/832) ([evgeni](https://github.com/evgeni))

**Fixed bugs:**

- Move away from systemd::service\_limits [\#837](https://github.com/theforeman/puppet-foreman_proxy/pull/837) ([ekohl](https://github.com/ekohl))

## [25.3.0](https://github.com/theforeman/puppet-foreman_proxy/tree/25.3.0) (2024-02-19)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/25.2.0...25.3.0)

**Implemented enhancements:**

- Add HDM smart proxy [\#829](https://github.com/theforeman/puppet-foreman_proxy/pull/829) ([tuxmea](https://github.com/tuxmea))
- add examples and acceptance tests for container\_gateway [\#825](https://github.com/theforeman/puppet-foreman_proxy/pull/825) ([evgeni](https://github.com/evgeni))
- Support EL9 [\#823](https://github.com/theforeman/puppet-foreman_proxy/pull/823) ([ekohl](https://github.com/ekohl))

**Fixed bugs:**

- Make exception to grub\_efi\_path for OracleLinux [\#828](https://github.com/theforeman/puppet-foreman_proxy/pull/828) ([eb4x](https://github.com/eb4x))
- Fixes [\#37078](https://projects.theforeman.org/issues/37078) - ensure salt installation is done before configuration [\#826](https://github.com/theforeman/puppet-foreman_proxy/pull/826) ([knoppi](https://github.com/knoppi))

## [25.2.0](https://github.com/theforeman/puppet-foreman_proxy/tree/25.2.0) (2023-11-15)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/25.1.0...25.2.0)

**Implemented enhancements:**

- Mark compatible with theforeman/foreman 24.x & theforeman/tftp 9.x [\#819](https://github.com/theforeman/puppet-foreman_proxy/pull/819) ([ekohl](https://github.com/ekohl))
- Mark compatible with puppet-extlib 7.x [\#818](https://github.com/theforeman/puppet-foreman_proxy/pull/818) ([ekohl](https://github.com/ekohl))
- allow puppet/mosquitto 2.x [\#816](https://github.com/theforeman/puppet-foreman_proxy/pull/816) ([jhoblitt](https://github.com/jhoblitt))
- Fixes [\#36772](https://projects.theforeman.org/issues/36772) - Add support for container gateway sqlite timeout tuning [\#813](https://github.com/theforeman/puppet-foreman_proxy/pull/813) ([ianballou](https://github.com/ianballou))
- Add Puppet 8 support [\#811](https://github.com/theforeman/puppet-foreman_proxy/pull/811) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- Set group owner to foreman-proxy for Salt config [\#815](https://github.com/theforeman/puppet-foreman_proxy/pull/815) ([maximiliankolb](https://github.com/maximiliankolb))

## [25.1.0](https://github.com/theforeman/puppet-foreman_proxy/tree/25.1.0) (2023-08-17)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/25.0.0...25.1.0)

**Implemented enhancements:**

- puppetlabs/stdlib: Allow 9.x [\#810](https://github.com/theforeman/puppet-foreman_proxy/pull/810) ([bastelfreak](https://github.com/bastelfreak))
- Add parameter to manage service [\#809](https://github.com/theforeman/puppet-foreman_proxy/pull/809) ([chr1s692](https://github.com/chr1s692))

## [25.0.0](https://github.com/theforeman/puppet-foreman_proxy/tree/25.0.0) (2023-05-16)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/24.2.0...25.0.0)

**Breaking changes:**

- Refs [\#36345](https://projects.theforeman.org/issues/36345) - Raise minimum Puppet version to 7.0.0 [\#805](https://github.com/theforeman/puppet-foreman_proxy/pull/805) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Mark compatible with theforeman/foreman 23.x [\#807](https://github.com/theforeman/puppet-foreman_proxy/pull/807) ([ekohl](https://github.com/ekohl))
- Mark compatible with theforeman/dns 10.x & theforeman/dhcp 9.x [\#806](https://github.com/theforeman/puppet-foreman_proxy/pull/806) ([ekohl](https://github.com/ekohl))
- Simplify grub\_efi\_path on redhat family [\#804](https://github.com/theforeman/puppet-foreman_proxy/pull/804) ([eb4x](https://github.com/eb4x))

## [24.2.0](https://github.com/theforeman/puppet-foreman_proxy/tree/24.2.0) (2023-03-21)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/24.1.0...24.2.0)

**Implemented enhancements:**

- Add parameters to ensure OpenSCAP Ansible module state [\#802](https://github.com/theforeman/puppet-foreman_proxy/pull/802) ([ekohl](https://github.com/ekohl))
- ensure the collection pkg to be installed [\#801](https://github.com/theforeman/puppet-foreman_proxy/pull/801) ([evgeni](https://github.com/evgeni))
- default to theforeman.foreman.foreman callback on all Debians [\#800](https://github.com/theforeman/puppet-foreman_proxy/pull/800) ([evgeni](https://github.com/evgeni))

**Merged pull requests:**

- Remove Puppet 6+ conditionals in fixtures [\#797](https://github.com/theforeman/puppet-foreman_proxy/pull/797) ([ekohl](https://github.com/ekohl))

## [24.1.0](https://github.com/theforeman/puppet-foreman_proxy/tree/24.1.0) (2023-02-02)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/24.0.1...24.1.0)

**Implemented enhancements:**

- Fixes [\#35925](https://projects.theforeman.org/issues/35925) - Enable ssh server keepalive for ansible [\#795](https://github.com/theforeman/puppet-foreman_proxy/pull/795) ([adamruzicka](https://github.com/adamruzicka))
- Fixes [\#35899](https://projects.theforeman.org/issues/35899) - Expose new sp-rex-ssh tunables [\#794](https://github.com/theforeman/puppet-foreman_proxy/pull/794) ([adamruzicka](https://github.com/adamruzicka))

**Fixed bugs:**

- require the grub packages before copying files on RedHat too [\#796](https://github.com/theforeman/puppet-foreman_proxy/pull/796) ([evgeni](https://github.com/evgeni))

## [24.0.1](https://github.com/theforeman/puppet-foreman_proxy/tree/24.0.1) (2022-12-14)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/24.0.0...24.0.1)

**Fixed bugs:**

- Fixes [\#35809](https://projects.theforeman.org/issues/35809) - always enable rex when enabling ansible [\#791](https://github.com/theforeman/puppet-foreman_proxy/pull/791) ([evgeni](https://github.com/evgeni))

## [24.0.0](https://github.com/theforeman/puppet-foreman_proxy/tree/24.0.0) (2022-11-04)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/23.0.1...24.0.0)

**Breaking changes:**

- drop abrt and chef plugins [\#789](https://github.com/theforeman/puppet-foreman_proxy/pull/789) ([evgeni](https://github.com/evgeni))
- Change module feature default to capitalize [\#788](https://github.com/theforeman/puppet-foreman_proxy/pull/788) ([ekohl](https://github.com/ekohl))
- Drop ansible-runner repository management [\#780](https://github.com/theforeman/puppet-foreman_proxy/pull/780) ([ehelms](https://github.com/ehelms))
- Fixes [\#35455](https://projects.theforeman.org/issues/35455) - Generate an environment file for ansible [\#777](https://github.com/theforeman/puppet-foreman_proxy/pull/777) ([adamruzicka](https://github.com/adamruzicka))
- Drop reports proxy plugin [\#776](https://github.com/theforeman/puppet-foreman_proxy/pull/776) ([evgeni](https://github.com/evgeni))
- Refs [\#31118](https://projects.theforeman.org/issues/31118) - Remove daemon option from settings.yaml [\#630](https://github.com/theforeman/puppet-foreman_proxy/pull/630) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Allow theforeman/tftp 8.x [\#787](https://github.com/theforeman/puppet-foreman_proxy/pull/787) ([ekohl](https://github.com/ekohl))
- Fixes [\#35680](https://projects.theforeman.org/issues/35680): Add support to configure registration\_url [\#786](https://github.com/theforeman/puppet-foreman_proxy/pull/786) ([ehelms](https://github.com/ehelms))
- Update dhcp infoblox plugin parameters due to updates in plugin itself [\#785](https://github.com/theforeman/puppet-foreman_proxy/pull/785) ([timdeluxe](https://github.com/timdeluxe))
- Fixes [\#35531](https://projects.theforeman.org/issues/35531) - Add Puppet module support to OpenSCAP plugin [\#781](https://github.com/theforeman/puppet-foreman_proxy/pull/781) ([ekohl](https://github.com/ekohl))
- Automatically include plugin dns provider classes [\#779](https://github.com/theforeman/puppet-foreman_proxy/pull/779) ([ekohl](https://github.com/ekohl))
- Bring config files closer to packaged versions [\#778](https://github.com/theforeman/puppet-foreman_proxy/pull/778) ([ekohl](https://github.com/ekohl))
- Fixes [\#35396](https://projects.theforeman.org/issues/35396) - allow non-root user to read Salt master config file [\#775](https://github.com/theforeman/puppet-foreman_proxy/pull/775) ([bastian-src](https://github.com/bastian-src))
- manage discovery plugin config file [\#772](https://github.com/theforeman/puppet-foreman_proxy/pull/772) ([jhoblitt](https://github.com/jhoblitt))

## [23.0.1](https://github.com/theforeman/puppet-foreman_proxy/tree/23.0.1) (2022-08-04)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/23.0.0...23.0.1)

**Fixed bugs:**

- Allow theforeman/foreman 21.x [\#770](https://github.com/theforeman/puppet-foreman_proxy/pull/770) ([ekohl](https://github.com/ekohl))

## [23.0.0](https://github.com/theforeman/puppet-foreman_proxy/tree/23.0.0) (2022-08-04)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/22.1.3...23.0.0)

**Breaking changes:**

- Refs [\#35184](https://projects.theforeman.org/issues/35184) - Drop puppetca\_http\_api provider [\#768](https://github.com/theforeman/puppet-foreman_proxy/pull/768) ([ekohl](https://github.com/ekohl))
- Drop EL7 support [\#767](https://github.com/theforeman/puppet-foreman_proxy/pull/767) ([ekohl](https://github.com/ekohl))
- drop support for Debian 10 Buster [\#766](https://github.com/theforeman/puppet-foreman_proxy/pull/766) ([evgeni](https://github.com/evgeni))

**Implemented enhancements:**

- Use modern networking facts & correct data types on IPs [\#764](https://github.com/theforeman/puppet-foreman_proxy/pull/764) ([ekohl](https://github.com/ekohl))
- Update to voxpupuli-test 5 [\#763](https://github.com/theforeman/puppet-foreman_proxy/pull/763) ([ekohl](https://github.com/ekohl))
- add foreman::shell param [\#742](https://github.com/theforeman/puppet-foreman_proxy/pull/742) ([jhoblitt](https://github.com/jhoblitt))

## [22.1.3](https://github.com/theforeman/puppet-foreman_proxy/tree/22.1.3) (2022-05-11)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/22.1.2...22.1.3)

**Fixed bugs:**

- ensure config notifies mosquitto [\#758](https://github.com/theforeman/puppet-foreman_proxy/pull/758) ([evgeni](https://github.com/evgeni))

## [22.1.2](https://github.com/theforeman/puppet-foreman_proxy/tree/22.1.2) (2022-05-05)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/22.1.1...22.1.2)

**Fixed bugs:**

- notify the mosquitto service of changes to the acl and certs [\#756](https://github.com/theforeman/puppet-foreman_proxy/pull/756) ([evgeni](https://github.com/evgeni))
- also chain private keys from puppet-certs correctly [\#755](https://github.com/theforeman/puppet-foreman_proxy/pull/755) ([evgeni](https://github.com/evgeni))

## [22.1.1](https://github.com/theforeman/puppet-foreman_proxy/tree/22.1.1) (2022-05-04)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/22.1.0...22.1.1)

**Fixed bugs:**

- 22.1.0 release is missing dep on puppet/mosquitto [\#751](https://github.com/theforeman/puppet-foreman_proxy/issues/751)
- Ensure certs were deployed before we try to source them [\#753](https://github.com/theforeman/puppet-foreman_proxy/pull/753) ([evgeni](https://github.com/evgeni))
- add missing dep on puppet/mosquitto [\#752](https://github.com/theforeman/puppet-foreman_proxy/pull/752) ([jhoblitt](https://github.com/jhoblitt))

## [22.1.0](https://github.com/theforeman/puppet-foreman_proxy/tree/22.1.0) (2022-05-03)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/22.0.0...22.1.0)

**Implemented enhancements:**

- allow theforeman/foreman 20.x [\#748](https://github.com/theforeman/puppet-foreman_proxy/pull/748) ([evgeni](https://github.com/evgeni))

## [22.0.0](https://github.com/theforeman/puppet-foreman_proxy/tree/22.0.0) (2022-04-29)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/21.0.0...22.0.0)

**Breaking changes:**

- Fixes [\#34774](https://projects.theforeman.org/issues/34774) - don't expose tftp syslinux files directly [\#738](https://github.com/theforeman/puppet-foreman_proxy/pull/738) ([evgeni](https://github.com/evgeni))
- Rename remote\_execution plugin to foreman\_proxy::plugin::remote\_execution [\#734](https://github.com/theforeman/puppet-foreman_proxy/pull/734) ([ehelms](https://github.com/ehelms))

**Implemented enhancements:**

- Support BMC redfish integration [\#747](https://github.com/theforeman/puppet-foreman_proxy/pull/747) ([laugmanuel](https://github.com/laugmanuel))
- Refs [\#34239](https://projects.theforeman.org/issues/34239) - Add mqtt\_broker and mqtt\_port settings to REX config [\#745](https://github.com/theforeman/puppet-foreman_proxy/pull/745) ([ehelms](https://github.com/ehelms))
- Add support for cleaning up mosquitto when switching to SSH [\#744](https://github.com/theforeman/puppet-foreman_proxy/pull/744) ([ehelms](https://github.com/ehelms))
- add foreman\_proxy::plugin::remote\_execution::ssh::ssh\_log\_level param  [\#739](https://github.com/theforeman/puppet-foreman_proxy/pull/739) ([jhoblitt](https://github.com/jhoblitt))
- Fixes [\#34239](https://projects.theforeman.org/issues/34239): Add pull-mqtt support to smart\_proxy\_remote\_execution [\#737](https://github.com/theforeman/puppet-foreman_proxy/pull/737) ([ehelms](https://github.com/ehelms))
- Add cockpit flag [\#735](https://github.com/theforeman/puppet-foreman_proxy/pull/735) ([ehelms](https://github.com/ehelms))
- Ensure the config directory, user and deal with a missing domain [\#733](https://github.com/theforeman/puppet-foreman_proxy/pull/733) ([ekohl](https://github.com/ekohl))
- Move REX ssh key management into separate class [\#727](https://github.com/theforeman/puppet-foreman_proxy/pull/727) ([wbclark](https://github.com/wbclark))

**Fixed bugs:**

- \[REX SSH Plugin\] Don't manage net-ssh-krb package [\#732](https://github.com/theforeman/puppet-foreman_proxy/pull/732) ([wbclark](https://github.com/wbclark))

## [21.0.0](https://github.com/theforeman/puppet-foreman_proxy/tree/21.0.0) (2022-02-08)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/20.1.0...21.0.0)

**Breaking changes:**

- Refs [\#34239](https://projects.theforeman.org/issues/34239) - Use mode parameter for remote\_execution\_ssh plugin [\#725](https://github.com/theforeman/puppet-foreman_proxy/pull/725) ([wbclark](https://github.com/wbclark))
- Drop dynflow\_core support [\#720](https://github.com/theforeman/puppet-foreman_proxy/pull/720) ([evgeni](https://github.com/evgeni))

**Implemented enhancements:**

- puppet/extlib: Allow 6.x [\#723](https://github.com/theforeman/puppet-foreman_proxy/pull/723) ([bastelfreak](https://github.com/bastelfreak))
- Reflect Foreman 3.2+ support for Debian 11 [\#722](https://github.com/theforeman/puppet-foreman_proxy/pull/722) ([ekohl](https://github.com/ekohl))
- Accept EPP-Template for Settings-File [\#715](https://github.com/theforeman/puppet-foreman_proxy/pull/715) ([cocker-cc](https://github.com/cocker-cc))
- Fixes [\#33549](https://projects.theforeman.org/issues/33549) - Add parameter dhcp\_ipxefilename to set a value for DHCP's iPXE filename [\#704](https://github.com/theforeman/puppet-foreman_proxy/pull/704) ([hugendudel](https://github.com/hugendudel))
- Add autosign\_key\_file parameter and Salt Master configuration [\#696](https://github.com/theforeman/puppet-foreman_proxy/pull/696) ([bastian-src](https://github.com/bastian-src))

**Fixed bugs:**

- setfacl needs foreman\_proxy::user to exist [\#719](https://github.com/theforeman/puppet-foreman_proxy/pull/719) ([eb4x](https://github.com/eb4x))

## [20.1.0](https://github.com/theforeman/puppet-foreman_proxy/tree/20.1.0) (2021-11-09)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/20.0.0...20.1.0)

**Implemented enhancements:**

- Allow theforeman/foreman 19.0.0 [\#716](https://github.com/theforeman/puppet-foreman_proxy/pull/716) ([ehelms](https://github.com/ehelms))

**Fixed bugs:**

- Fixes [\#33864](https://projects.theforeman.org/issues/33864) - disable registration by default [\#714](https://github.com/theforeman/puppet-foreman_proxy/pull/714) ([evgeni](https://github.com/evgeni))

## [20.0.0](https://github.com/theforeman/puppet-foreman_proxy/tree/20.0.0) (2021-11-05)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/19.0.0...20.0.0)

**Breaking changes:**

- Drop Ubuntu 18.04 support [\#713](https://github.com/theforeman/puppet-foreman_proxy/pull/713) ([ekohl](https://github.com/ekohl))
- Fixes [\#33790](https://projects.theforeman.org/issues/33790) - Mark host where the installer is running as smart-proxy [\#687](https://github.com/theforeman/puppet-foreman_proxy/pull/687) ([adamruzicka](https://github.com/adamruzicka))

**Implemented enhancements:**

- Bump to 20.0.0 and update compatibility table [\#712](https://github.com/theforeman/puppet-foreman_proxy/pull/712) ([ekohl](https://github.com/ekohl))
- Shift theforeman/puppet to a soft dependency and drop from metadata.json [\#710](https://github.com/theforeman/puppet-foreman_proxy/pull/710) ([ehelms](https://github.com/ehelms))
- Support theforeman/dhcp 8+ [\#708](https://github.com/theforeman/puppet-foreman_proxy/pull/708) ([ehelms](https://github.com/ehelms))
- Refs [\#33760](https://projects.theforeman.org/issues/33760) - Add reports proxy plugin [\#707](https://github.com/theforeman/puppet-foreman_proxy/pull/707) ([ofedoren](https://github.com/ofedoren))
- Fixes [\#33688](https://projects.theforeman.org/issues/33688) - Set max\_files to unlimited for TFTP directories [\#706](https://github.com/theforeman/puppet-foreman_proxy/pull/706) ([thomas-merz](https://github.com/thomas-merz))
- Allow stdlib 8.x dependency [\#702](https://github.com/theforeman/puppet-foreman_proxy/pull/702) ([jfroche](https://github.com/jfroche))
- Default package versions to installed instead of present [\#701](https://github.com/theforeman/puppet-foreman_proxy/pull/701) ([ehelms](https://github.com/ehelms))
- Expose rhsm\_url setting in foreman\_proxy::plugin::pulp [\#700](https://github.com/theforeman/puppet-foreman_proxy/pull/700) ([wbclark](https://github.com/wbclark))
- Fixes [\#33162](https://projects.theforeman.org/issues/33162) - Set value for Ansible collections\_paths [\#693](https://github.com/theforeman/puppet-foreman_proxy/pull/693) ([xprazak2](https://github.com/xprazak2))

**Fixed bugs:**

- Fixes [\#33808](https://projects.theforeman.org/issues/33808): Make templates listen on both again [\#711](https://github.com/theforeman/puppet-foreman_proxy/pull/711) ([ekohl](https://github.com/ekohl))

## [19.0.0](https://github.com/theforeman/puppet-foreman_proxy/tree/19.0.0) (2021-07-23)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/18.1.0...19.0.0)

**Breaking changes:**

- Drop Puppet 5 support [\#680](https://github.com/theforeman/puppet-foreman_proxy/pull/680) ([ehelms](https://github.com/ehelms))
- Remove Foreman repository parameters [\#677](https://github.com/theforeman/puppet-foreman_proxy/pull/677) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Fixes [\#32710](https://projects.theforeman.org/issues/32710) - tftp support for Rocky Linux and AlmaLinux [\#690](https://github.com/theforeman/puppet-foreman_proxy/pull/690) ([maccelf](https://github.com/maccelf))
- Allow puppet-dhcp 7.0.0 [\#689](https://github.com/theforeman/puppet-foreman_proxy/pull/689) ([ehelms](https://github.com/ehelms))
- Allow puppet-foreman 18.0.0 [\#684](https://github.com/theforeman/puppet-foreman_proxy/pull/684) ([ehelms](https://github.com/ehelms))
- Add client\_authentication parameter to plugin::pulp  [\#682](https://github.com/theforeman/puppet-foreman_proxy/pull/682) ([ehelms](https://github.com/ehelms))
- Add ACD plugin support [\#679](https://github.com/theforeman/puppet-foreman_proxy/pull/679) ([sbernhard](https://github.com/sbernhard))
- Lazily load tftp directories [\#674](https://github.com/theforeman/puppet-foreman_proxy/pull/674) ([ekohl](https://github.com/ekohl))
- Allow Puppet 7 compatible versions of mods [\#672](https://github.com/theforeman/puppet-foreman_proxy/pull/672) ([ekohl](https://github.com/ekohl))
- Move all static vars from params to init [\#634](https://github.com/theforeman/puppet-foreman_proxy/pull/634) ([ekohl](https://github.com/ekohl))

## [18.1.0](https://github.com/theforeman/puppet-foreman_proxy/tree/18.1.0) (2021-04-30)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/18.0.0...18.1.0)

**Implemented enhancements:**

- Support Ubuntu 20.04 [\#669](https://github.com/theforeman/puppet-foreman_proxy/pull/669) ([ekohl](https://github.com/ekohl))
- Allow puppet-puppet \< 16.0.0 [\#665](https://github.com/theforeman/puppet-foreman_proxy/pull/665) ([wbclark](https://github.com/wbclark))
- don't manage runner repo on Debian [\#664](https://github.com/theforeman/puppet-foreman_proxy/pull/664) ([evgeni](https://github.com/evgeni))

## [18.0.0](https://github.com/theforeman/puppet-foreman_proxy/tree/18.0.0) (2021-04-27)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/17.1.1...18.0.0)

**Breaking changes:**

-  Fixes [\#31893](https://projects.theforeman.org/issues/31893) - make theforeman.foreman.foreman default callback on RH [\#661](https://github.com/theforeman/puppet-foreman_proxy/pull/661) ([evgeni](https://github.com/evgeni))
- Fixes [\#32235](https://projects.theforeman.org/issues/32235),\#19494 - Run Dynflow within smart-proxy on EL\* [\#655](https://github.com/theforeman/puppet-foreman_proxy/pull/655) ([adamruzicka](https://github.com/adamruzicka))
- Update Pulp plugin to drop Pulp 2 [\#638](https://github.com/theforeman/puppet-foreman_proxy/pull/638) ([ehelms](https://github.com/ehelms))

**Implemented enhancements:**

- Refs [\#31893](https://projects.theforeman.org/issues/31893) - make ansible callback configurable [\#662](https://github.com/theforeman/puppet-foreman_proxy/pull/662) ([evgeni](https://github.com/evgeni))
- Mark compatible with Foreman 17.x [\#658](https://github.com/theforeman/puppet-foreman_proxy/pull/658) ([ekohl](https://github.com/ekohl))
- Remove Puppet version check [\#657](https://github.com/theforeman/puppet-foreman_proxy/pull/657) ([ekohl](https://github.com/ekohl))
- Add smart\_proxy\_dns\_route53 plugin support [\#656](https://github.com/theforeman/puppet-foreman_proxy/pull/656) ([Nevermore24](https://github.com/Nevermore24))
- Support Puppet 7 [\#652](https://github.com/theforeman/puppet-foreman_proxy/pull/652) ([ekohl](https://github.com/ekohl))
- Add shellhooks plugin [\#651](https://github.com/theforeman/puppet-foreman_proxy/pull/651) ([adamruzicka](https://github.com/adamruzicka))

## [17.1.1](https://github.com/theforeman/puppet-foreman_proxy/tree/17.1.1) (2021-03-18)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/17.1.0...17.1.1)

**Fixed bugs:**

- Fixes [\#32078](https://projects.theforeman.org/issues/32078) - explicitly notify dynflow core service on changes [\#653](https://github.com/theforeman/puppet-foreman_proxy/pull/653) ([evgeni](https://github.com/evgeni))

## [17.1.0](https://github.com/theforeman/puppet-foreman_proxy/tree/17.1.0) (2021-02-04)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/17.0.0...17.1.0)

**Implemented enhancements:**

- Fixes [\#31642](https://projects.theforeman.org/issues/31642) - Add container gateway support [\#643](https://github.com/theforeman/puppet-foreman_proxy/pull/643) ([ianballou](https://github.com/ianballou))

## [17.0.0](https://github.com/theforeman/puppet-foreman_proxy/tree/17.0.0) (2021-01-29)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/16.0.0...17.0.0)

**Breaking changes:**

- Fixes [\#30449](https://projects.theforeman.org/issues/30449) - Do not require TFTP for HTTPBoot [\#608](https://github.com/theforeman/puppet-foreman_proxy/pull/608) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Fixes [\#31415](https://projects.theforeman.org/issues/31415) - Expose DHCP's ping\_free\_ip option [\#635](https://github.com/theforeman/puppet-foreman_proxy/pull/635) ([ekohl](https://github.com/ekohl))

**Fixed bugs:**

- Fixes [\#31430](https://projects.theforeman.org/issues/31430) - use correct key and server for ansible-runner deb  [\#637](https://github.com/theforeman/puppet-foreman_proxy/pull/637) ([evgeni](https://github.com/evgeni))

## [16.0.0](https://github.com/theforeman/puppet-foreman_proxy/tree/16.0.0) (2020-10-30)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/15.3.0...16.0.0)

**Breaking changes:**

- Fixes [\#30950](https://projects.theforeman.org/issues/30950) - Enable SmartProxy Registration module [\#619](https://github.com/theforeman/puppet-foreman_proxy/pull/619) ([stejskalleos](https://github.com/stejskalleos))
- Fixes [\#30669](https://projects.theforeman.org/issues/30669) - Removing puppetrun options [\#618](https://github.com/theforeman/puppet-foreman_proxy/pull/618) ([domitea](https://github.com/domitea))

**Implemented enhancements:**

- Refs [\#29830](https://projects.theforeman.org/issues/29830) - Move discovery plugin docs to RDOC and split out advanced parameters [\#626](https://github.com/theforeman/puppet-foreman_proxy/pull/626) ([ehelms](https://github.com/ehelms))
- Do not set ACLs on DHCP leases directory [\#623](https://github.com/theforeman/puppet-foreman_proxy/pull/623) ([ekohl](https://github.com/ekohl))

**Fixed bugs:**

- Do not set recursive ACLs on dhcp [\#621](https://github.com/theforeman/puppet-foreman_proxy/pull/621) ([ekohl](https://github.com/ekohl))

## [15.2.0](https://github.com/theforeman/puppet-foreman_proxy/tree/15.2.0) (2020-09-23)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/15.1.0...15.2.0)

**Implemented enhancements:**

- Fixes [\#30489](https://projects.theforeman.org/issues/30489) - CVE-2020-14335 world-readable OMAPI [\#614](https://github.com/theforeman/puppet-foreman_proxy/pull/614) ([ezr-ondrej](https://github.com/ezr-ondrej))
- Fixes [\#30489](https://projects.theforeman.org/issues/30489) - CVE-2020-14335 dhcpd.conf permissions [\#615](https://github.com/theforeman/puppet-foreman_proxy/pull/615) ([ezr-ondrej](https://github.com/ezr-ondrej))

**Fixed bugs:**

- Fixes [\#30072](https://projects.theforeman.org/issues/30072) - update grub default template [\#598](https://github.com/theforeman/puppet-foreman_proxy/pull/598) ([lzap](https://github.com/lzap))

## [15.1.0](https://github.com/theforeman/puppet-foreman_proxy/tree/15.1.0) (2020-08-20)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/15.0.0...15.1.0)

**Implemented enhancements:**

- Fixes [\#30632](https://projects.theforeman.org/issues/30632) - Set up HTTPClients in DHCP [\#611](https://github.com/theforeman/puppet-foreman_proxy/pull/611) ([ekohl](https://github.com/ekohl))

## [15.0.0](https://github.com/theforeman/puppet-foreman_proxy/tree/15.0.0) (2020-08-07)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/14.0.2...15.0.0)

**Breaking changes:**

- Drop puppetca\_split\_configs parameter [\#605](https://github.com/theforeman/puppet-foreman_proxy/pull/605) ([ekohl](https://github.com/ekohl))
- Fixes [\#30198](https://projects.theforeman.org/issues/30198) - Disable TFTP by default [\#602](https://github.com/theforeman/puppet-foreman_proxy/pull/602) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- don't fail on upcase\(\) when domain fact is undefined [\#607](https://github.com/theforeman/puppet-foreman_proxy/pull/607) ([wbclark](https://github.com/wbclark))

**Fixed bugs:**

- Fix tftp on RedHat 8 [\#609](https://github.com/theforeman/puppet-foreman_proxy/pull/609) ([dgoetz](https://github.com/dgoetz))
- Improve the readability of the provided grub.cfg [\#606](https://github.com/theforeman/puppet-foreman_proxy/pull/606) ([illumino](https://github.com/illumino))

## [14.0.2](https://github.com/theforeman/puppet-foreman_proxy/tree/14.0.2) (2020-06-30)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/14.0.1...14.0.2)

**Fixed bugs:**

- Fixes [\#30240](https://projects.theforeman.org/issues/30240) - compat with theforeman/dns 8.x [\#603](https://github.com/theforeman/puppet-foreman_proxy/pull/603) ([ekohl](https://github.com/ekohl))

## [14.0.1](https://github.com/theforeman/puppet-foreman_proxy/tree/14.0.1) (2020-06-15)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/14.0.0...14.0.1)

**Fixed bugs:**

- Fixes [\#30121](https://projects.theforeman.org/issues/30121) - Generate SSH keys in PEM format [\#600](https://github.com/theforeman/puppet-foreman_proxy/pull/600) ([adamruzicka](https://github.com/adamruzicka))
- replace nsupdate dependency on FreeBSD [\#597](https://github.com/theforeman/puppet-foreman_proxy/pull/597) ([fraenki](https://github.com/fraenki))

## [14.0.0](https://github.com/theforeman/puppet-foreman_proxy/tree/14.0.0) (2020-05-16)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/13.0.0...14.0.0)

**Breaking changes:**

- Use modern facts [\#586](https://github.com/theforeman/puppet-foreman_proxy/issues/586)
- Remove old Red Hat TFTP install methods [\#590](https://github.com/theforeman/puppet-foreman_proxy/pull/590) ([ekohl](https://github.com/ekohl))
- Move Ruby package prefix to params [\#575](https://github.com/theforeman/puppet-foreman_proxy/pull/575) ([ekohl](https://github.com/ekohl))
- Drop group parameter on plugins [\#573](https://github.com/theforeman/puppet-foreman_proxy/pull/573) ([ekohl](https://github.com/ekohl))
- Introduce foreman\_proxy::globals [\#572](https://github.com/theforeman/puppet-foreman_proxy/pull/572) ([ekohl](https://github.com/ekohl))
- Remove redundant parameters [\#571](https://github.com/theforeman/puppet-foreman_proxy/pull/571) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Switch AIO detection to use aio\_agent\_version fact [\#585](https://github.com/theforeman/puppet-foreman_proxy/issues/585)
- Update module dependencies to allow EL8 supported versions [\#595](https://github.com/theforeman/puppet-foreman_proxy/pull/595) ([wbclark](https://github.com/wbclark))
- Fixes [\#29213](https://projects.theforeman.org/issues/29213) - Support el8 [\#582](https://github.com/theforeman/puppet-foreman_proxy/pull/582) ([wbclark](https://github.com/wbclark))
- add support for flatcar [\#579](https://github.com/theforeman/puppet-foreman_proxy/pull/579) ([TheKangaroo](https://github.com/TheKangaroo))
- Allow extlib 5.x [\#578](https://github.com/theforeman/puppet-foreman_proxy/pull/578) ([mmoll](https://github.com/mmoll))
- Declare features on SSH and Pulp modules [\#570](https://github.com/theforeman/puppet-foreman_proxy/pull/570) ([ekohl](https://github.com/ekohl))
- Document classes using puppet-strings [\#568](https://github.com/theforeman/puppet-foreman_proxy/pull/568) ([ekohl](https://github.com/ekohl))
- Refactor modules, plugins and providers design [\#564](https://github.com/theforeman/puppet-foreman_proxy/pull/564) ([ekohl](https://github.com/ekohl))
- Fixes [\#29005](https://projects.theforeman.org/issues/29005) - Make IPv4 optional in proxydns [\#521](https://github.com/theforeman/puppet-foreman_proxy/pull/521) ([ekohl](https://github.com/ekohl))

**Fixed bugs:**

- correct needed foreman dependency [\#596](https://github.com/theforeman/puppet-foreman_proxy/pull/596) ([mmoll](https://github.com/mmoll))
- Fixes [\#29690](https://projects.theforeman.org/issues/29690) - install shimx64.efi and shim.efi [\#592](https://github.com/theforeman/puppet-foreman_proxy/pull/592) ([lzap](https://github.com/lzap))
- Use $f\_p::plugin::dynflow::external\_core [\#574](https://github.com/theforeman/puppet-foreman_proxy/pull/574) ([ekohl](https://github.com/ekohl))
- Fix chef plugin listen on [\#567](https://github.com/theforeman/puppet-foreman_proxy/pull/567) ([ekohl](https://github.com/ekohl))

**Closed issues:**

- Smart proxy plugin packages not lining up [\#561](https://github.com/theforeman/puppet-foreman_proxy/issues/561)

**Merged pull requests:**

- add Ubuntu integration tests [\#577](https://github.com/theforeman/puppet-foreman_proxy/pull/577) ([mmoll](https://github.com/mmoll))
- Update the compatibility matrix in the README [\#563](https://github.com/theforeman/puppet-foreman_proxy/pull/563) ([ekohl](https://github.com/ekohl))

## [13.0.0](https://github.com/theforeman/puppet-foreman_proxy/tree/13.0.0) (2020-02-12)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/12.1.0...13.0.0)

**Breaking changes:**

- Fixes [\#28877](https://projects.theforeman.org/issues/28877) - Dynamically determine Pulp Puppet dir [\#558](https://github.com/theforeman/puppet-foreman_proxy/pull/558) ([ekohl](https://github.com/ekohl))
- use pulpcore naming convention [\#556](https://github.com/theforeman/puppet-foreman_proxy/pull/556) ([wbclark](https://github.com/wbclark))
- Drop Archlinux support [\#553](https://github.com/theforeman/puppet-foreman_proxy/pull/553) ([ekohl](https://github.com/ekohl))
- Drop Debian 9 and Ubuntu 16.04, add Debian 10 [\#548](https://github.com/theforeman/puppet-foreman_proxy/pull/548) ([mmoll](https://github.com/mmoll))
- Only manage ISC DHCP when using the ISC provider [\#547](https://github.com/theforeman/puppet-foreman_proxy/pull/547) ([ekohl](https://github.com/ekohl))
- Only manage DNS for the nsupdate provider [\#545](https://github.com/theforeman/puppet-foreman_proxy/pull/545) ([ekohl](https://github.com/ekohl))
- Drop database backends for the PowerDNS plugin [\#542](https://github.com/theforeman/puppet-foreman_proxy/pull/542) ([ekohl](https://github.com/ekohl))
- Handle smart proxy and plugins packaged for SCL [\#538](https://github.com/theforeman/puppet-foreman_proxy/pull/538) ([ehelms](https://github.com/ehelms))

**Implemented enhancements:**

- Allow new major versions of modules [\#559](https://github.com/theforeman/puppet-foreman_proxy/pull/559) ([ekohl](https://github.com/ekohl))
- Add Pulp 3 HTTP URLs [\#549](https://github.com/theforeman/puppet-foreman_proxy/pull/549) ([ekohl](https://github.com/ekohl))

**Fixed bugs:**

- Fixes [\#28681](https://projects.theforeman.org/issues/28681) - Listen on all dynflow IPs [\#557](https://github.com/theforeman/puppet-foreman_proxy/pull/557) ([ekohl](https://github.com/ekohl))
- Fixes [\#28559](https://projects.theforeman.org/issues/28559) - keep default ssh args [\#554](https://github.com/theforeman/puppet-foreman_proxy/pull/554) ([ares](https://github.com/ares))
- Fix tests by using a better IPv6 check [\#544](https://github.com/theforeman/puppet-foreman_proxy/pull/544) ([ekohl](https://github.com/ekohl))

**Merged pull requests:**

- provide no path for pulp3 api url [\#552](https://github.com/theforeman/puppet-foreman_proxy/pull/552) ([jlsherrill](https://github.com/jlsherrill))
- Refactor plugin parameter handling [\#500](https://github.com/theforeman/puppet-foreman_proxy/pull/500) ([ekohl](https://github.com/ekohl))

## [12.1.0](https://github.com/theforeman/puppet-foreman_proxy/tree/12.1.0) (2019-10-25)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/12.0.1...12.1.0)

**Implemented enhancements:**

- Allow configuring saltfile path for salt [\#530](https://github.com/theforeman/puppet-foreman_proxy/pull/530) ([adamruzicka](https://github.com/adamruzicka))

**Fixed bugs:**

- Gracefully handle a missing IP address [\#537](https://github.com/theforeman/puppet-foreman_proxy/pull/537) ([ekohl](https://github.com/ekohl))
- Fixes [\#27552](https://projects.theforeman.org/issues/27552) - Fix journald logging [\#531](https://github.com/theforeman/puppet-foreman_proxy/pull/531) ([ekohl](https://github.com/ekohl))

**Merged pull requests:**

- Allow theforeman/foreman 13.x [\#539](https://github.com/theforeman/puppet-foreman_proxy/pull/539) ([ekohl](https://github.com/ekohl))
- Remove unused setting from pulp3 [\#532](https://github.com/theforeman/puppet-foreman_proxy/pull/532) ([ekohl](https://github.com/ekohl))

## [12.0.1](https://github.com/theforeman/puppet-foreman_proxy/tree/12.0.1) (2019-08-01)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/12.0.0...12.0.1)

**Fixed bugs:**

- Re-add :puppet\_version setting to puppet.yml [\#528](https://github.com/theforeman/puppet-foreman_proxy/pull/528) ([antaflos](https://github.com/antaflos))

## [12.0.0](https://github.com/theforeman/puppet-foreman_proxy/tree/12.0.0) (2019-07-30)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/11.1.0...12.0.0)

Version 12.0.0 drops support for the Puppet 3 plugins in Foreman Proxy. This follows Foreman 1.23 but in practice this would have been nearly impossible to deploy with this module since it dropped support for running under Puppet 3 a long time ago.

It also changes the installation the Ansible plugin. It no longer installs python-requests but relies on packaging to do so. Doing this in packaging avoids the need for platform specific knowledge such as Python 2 or Python 3.

Lastly it installs ansible-runner by default when using the Ansible plugin. This is optional in Foreman 1.23 but the authors are looking to make this default in 1.24. Note that this installs an external repository since it's not present in EPEL nor Debian. The repository also includes a major new version of python2-psutil (5.x) compared to EPEL7 (2.x). There's an option to disable the repository management or the installation altogether.

**Breaking changes:**

- Fixes [\#27264](https://projects.theforeman.org/issues/27264) - Install ansible-runner package [\#515](https://github.com/theforeman/puppet-foreman_proxy/pull/515) ([ezr-ondrej](https://github.com/ezr-ondrej))
- Fixes [\#27053](https://projects.theforeman.org/issues/27053) - Drop Puppet 3 support from the proxy [\#514](https://github.com/theforeman/puppet-foreman_proxy/pull/514) ([ekohl](https://github.com/ekohl))
- Move python-requests to packaging for ansible [\#508](https://github.com/theforeman/puppet-foreman_proxy/pull/508) ([ehelms](https://github.com/ehelms))

**Implemented enhancements:**

- Fixes [\#27196](https://projects.theforeman.org/issues/27196) - Add roles\_path to ansible.cfg [\#518](https://github.com/theforeman/puppet-foreman_proxy/pull/518) ([xprazak2](https://github.com/xprazak2))
- Add support for external Dynflow core  [\#512](https://github.com/theforeman/puppet-foreman_proxy/pull/512) ([adamruzicka](https://github.com/adamruzicka))

**Fixed bugs:**

- Fixes [\#25481](https://projects.theforeman.org/issues/25481) - Set ProxyCommand=none for Ansible [\#511](https://github.com/theforeman/puppet-foreman_proxy/pull/511) ([ekohl](https://github.com/ekohl))

## [11.1.0](https://github.com/theforeman/puppet-foreman_proxy/tree/11.1.0) (2019-06-13)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/11.0.0...11.1.0)

**Implemented enhancements:**

- Allow for non tfm- packages on Fedora and RHEL8 [\#510](https://github.com/theforeman/puppet-foreman_proxy/pull/510) ([ehelms](https://github.com/ehelms))
- Fixes [\#26839](https://projects.theforeman.org/issues/26839) - add dns\_view option to plugin::dns::infoblox [\#507](https://github.com/theforeman/puppet-foreman_proxy/pull/507) ([lzap](https://github.com/lzap))

**Merged pull requests:**

- allow newer extlib version [\#509](https://github.com/theforeman/puppet-foreman_proxy/pull/509) ([mmoll](https://github.com/mmoll))
- Allow `puppetlabs/stdlib` 6.x [\#506](https://github.com/theforeman/puppet-foreman_proxy/pull/506) ([alexjfisher](https://github.com/alexjfisher))

## [11.0.0](https://github.com/theforeman/puppet-foreman_proxy/tree/11.0.0) (2019-04-17)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/10.1.0...11.0.0)

**Breaking changes:**

- drop Puppet 4 [\#498](https://github.com/theforeman/puppet-foreman_proxy/pull/498) ([mmoll](https://github.com/mmoll))
- drop FreeBSD 10 \(EOL\), add FreeBSD 12 [\#497](https://github.com/theforeman/puppet-foreman_proxy/pull/497) ([mmoll](https://github.com/mmoll))
- Add puppet http api support [\#488](https://github.com/theforeman/puppet-foreman_proxy/pull/488) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Add pulp3 options to the pulp plugin [\#503](https://github.com/theforeman/puppet-foreman_proxy/pull/503) ([ekohl](https://github.com/ekohl))
- Fixes [\#26388](https://projects.theforeman.org/issues/26388) - Clarify the managed parameter docs [\#499](https://github.com/theforeman/puppet-foreman_proxy/pull/499) ([ekohl](https://github.com/ekohl))
- Raise minimum foreman and puppet module versions [\#493](https://github.com/theforeman/puppet-foreman_proxy/pull/493) ([ekohl](https://github.com/ekohl))
- Ensure shim permissions [\#486](https://github.com/theforeman/puppet-foreman_proxy/pull/486) ([lzap](https://github.com/lzap))
- Fixes [\#26330](https://projects.theforeman.org/issues/26330) - Conditionally handle the puppet group [\#481](https://github.com/theforeman/puppet-foreman_proxy/pull/481) ([ekohl](https://github.com/ekohl))

**Fixed bugs:**

- Fix path to mco in example [\#496](https://github.com/theforeman/puppet-foreman_proxy/pull/496) ([smortex](https://github.com/smortex))

**Merged pull requests:**

- Allow newest module versions [\#502](https://github.com/theforeman/puppet-foreman_proxy/pull/502) ([ekohl](https://github.com/ekohl))

## [10.1.0](https://github.com/theforeman/puppet-foreman_proxy/tree/10.1.0) (2019-03-13)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/10.0.0...10.1.0)

**Implemented enhancements:**

- Fixes [\#25590](https://projects.theforeman.org/issues/25590) - Add httpboot support [\#494](https://github.com/theforeman/puppet-foreman_proxy/pull/494) ([ekohl](https://github.com/ekohl))
- Configure ansible's stdout\_callback to yaml for nicer output [\#492](https://github.com/theforeman/puppet-foreman_proxy/pull/492) ([iNecas](https://github.com/iNecas))
- remote\_execution ssh\_user management [\#483](https://github.com/theforeman/puppet-foreman_proxy/pull/483) ([alexjfisher](https://github.com/alexjfisher))

## [10.0.0](https://github.com/theforeman/puppet-foreman_proxy/tree/10.0.0) (2019-01-15)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/9.0.0...10.0.0)

**Breaking changes:**

- Remove puppetca\_modular parameter [\#476](https://github.com/theforeman/puppet-foreman_proxy/pull/476) ([ekohl](https://github.com/ekohl))
- Remove the default gateway [\#475](https://github.com/theforeman/puppet-foreman_proxy/pull/475) ([ekohl](https://github.com/ekohl))
- Disable repository management by default [\#472](https://github.com/theforeman/puppet-foreman_proxy/pull/472) ([ekohl](https://github.com/ekohl))
- Fixes [\#25591](https://projects.theforeman.org/issues/25591) - Remove $use\_ranges from infoblox dhcp [\#471](https://github.com/theforeman/puppet-foreman_proxy/pull/471) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Allow foreman and puppet 11.x versions [\#478](https://github.com/theforeman/puppet-foreman_proxy/pull/478) ([ekohl](https://github.com/ekohl))
- Add support for SSH BMC provider [\#470](https://github.com/theforeman/puppet-foreman_proxy/pull/470) ([mzhaase](https://github.com/mzhaase))
- Use modern facts and IP address validation [\#469](https://github.com/theforeman/puppet-foreman_proxy/pull/469) ([ekohl](https://github.com/ekohl))
- Add Puppet 6 support [\#468](https://github.com/theforeman/puppet-foreman_proxy/pull/468) ([ekohl](https://github.com/ekohl))
- Add setting for openscap report upload timeout [\#467](https://github.com/theforeman/puppet-foreman_proxy/pull/467) ([xprazak2](https://github.com/xprazak2))
- realm\_ad: Allow using unspecified DC [\#464](https://github.com/theforeman/puppet-foreman_proxy/pull/464) ([ananace](https://github.com/ananace))
- Install foreman-proxy-journald when JOURNALD is set [\#461](https://github.com/theforeman/puppet-foreman_proxy/pull/461) ([lzap](https://github.com/lzap))
- namespace extlib functions [\#460](https://github.com/theforeman/puppet-foreman_proxy/pull/460) ([mmoll](https://github.com/mmoll))

**Fixed bugs:**

- Fixes [\#25460](https://projects.theforeman.org/issues/25460) - only set the bind\_host to :: if IPv6 is available [\#466](https://github.com/theforeman/puppet-foreman_proxy/pull/466) ([evgeni](https://github.com/evgeni))
- fixes [\#24653](https://projects.theforeman.org/issues/24653) - only use grub mkimage on RHEL 7.4 [\#446](https://github.com/theforeman/puppet-foreman_proxy/pull/446) ([stbenjam](https://github.com/stbenjam))

**Merged pull requests:**

- Refs [\#25825](https://projects.theforeman.org/issues/25825) - Add tests around BMC SSH parameters [\#477](https://github.com/theforeman/puppet-foreman_proxy/pull/477) ([ekohl](https://github.com/ekohl))

## [9.0.0](https://github.com/theforeman/puppet-foreman_proxy/tree/9.0.0) (2018-10-18)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/8.0.2...9.0.0)

**Breaking changes:**

- Drop use of the stable repository [\#447](https://github.com/theforeman/puppet-foreman_proxy/pull/447) ([mmoll](https://github.com/mmoll))

**Implemented enhancements:**

- Added JOURNAL option for log\_file [\#458](https://github.com/theforeman/puppet-foreman_proxy/pull/458) ([lzap](https://github.com/lzap))
- Add {dns,network}\_view parameters to infoblox [\#455](https://github.com/theforeman/puppet-foreman_proxy/pull/455) ([ekohl](https://github.com/ekohl))
- Fixes [\#24505](https://projects.theforeman.org/issues/24505) - Add proxy name + url into scap settings [\#443](https://github.com/theforeman/puppet-foreman_proxy/pull/443) ([xprazak2](https://github.com/xprazak2))
- Fixes [\#24012](https://projects.theforeman.org/issues/24012) - Add PuppetCA providers settings [\#433](https://github.com/theforeman/puppet-foreman_proxy/pull/433) ([juliantodt](https://github.com/juliantodt))

**Fixed bugs:**

- Fixes [\#25036](https://projects.theforeman.org/issues/25036) - ensure proxy registration happens before puppet [\#456](https://github.com/theforeman/puppet-foreman_proxy/pull/456) ([evgeni](https://github.com/evgeni))
- Move the REX SSH directory to /var/lib/foreman-proxy [\#451](https://github.com/theforeman/puppet-foreman_proxy/pull/451) ([ekohl](https://github.com/ekohl))
- fixes [\#24690](https://projects.theforeman.org/issues/24690) - add symlink grub2/boot to ../boot [\#449](https://github.com/theforeman/puppet-foreman_proxy/pull/449) ([stbenjam](https://github.com/stbenjam))

**Closed issues:**

- Custom infoblox views [\#431](https://github.com/theforeman/puppet-foreman_proxy/issues/431)

**Merged pull requests:**

- Mark compatible with theforeman/puppet 10.x [\#462](https://github.com/theforeman/puppet-foreman_proxy/pull/462) ([ekohl](https://github.com/ekohl))
- allow extlib 3.x [\#459](https://github.com/theforeman/puppet-foreman_proxy/pull/459) ([mmoll](https://github.com/mmoll))
- Contain classes [\#457](https://github.com/theforeman/puppet-foreman_proxy/pull/457) ([ekohl](https://github.com/ekohl))
- allow puppetlabs-stdlib 5.x [\#450](https://github.com/theforeman/puppet-foreman_proxy/pull/450) ([mmoll](https://github.com/mmoll))

## [8.0.2](https://github.com/theforeman/puppet-foreman_proxy/tree/8.0.2) (2018-09-02)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/8.0.1...8.0.2)

**Closed issues:**

- forge-8.0.1 contains modules directory [\#454](https://github.com/theforeman/puppet-foreman_proxy/issues/454)

## [8.0.1](https://github.com/theforeman/puppet-foreman_proxy/tree/8.0.1) (2018-08-29)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/8.0.0...8.0.1)

## [8.0.0](https://github.com/theforeman/puppet-foreman_proxy/tree/8.0.0) (2018-07-16)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/7.2.3...8.0.0)

**Breaking changes:**

- Refs [\#24012](https://projects.theforeman.org/issues/24012) - Add PuppetCA providers settings [\#435](https://github.com/theforeman/puppet-foreman_proxy/pull/435) ([juliantodt](https://github.com/juliantodt))

**Implemented enhancements:**

- support Ubuntu/bionic [\#437](https://github.com/theforeman/puppet-foreman_proxy/pull/437) ([mmoll](https://github.com/mmoll))

## [7.2.3](https://github.com/theforeman/puppet-foreman_proxy/tree/7.2.3) (2018-07-11)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/7.2.2...7.2.3)

**Fixed bugs:**

- Fixes [\#24155](https://projects.theforeman.org/issues/24155) - explicitly set owner and permissions [\#436](https://github.com/theforeman/puppet-foreman_proxy/pull/436) ([lzap](https://github.com/lzap))

## [7.2.2](https://github.com/theforeman/puppet-foreman_proxy/tree/7.2.2) (2018-06-18)

[Full Changelog](https://github.com/theforeman/puppet-foreman_proxy/compare/7.2.1...7.2.2)

**Fixed bugs:**

- Fixes [\#23905](https://projects.theforeman.org/issues/23905) - Use /usr/share/foreman-proxy as ansible\_dir [\#432](https://github.com/theforeman/puppet-foreman_proxy/pull/432) ([dLobatog](https://github.com/dLobatog))

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

## [7.0.0](https://github.com/theforeman/puppet-foreman_proxy/tree/7.0.0) (2018-01-29)

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


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
