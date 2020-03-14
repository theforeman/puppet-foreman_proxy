# = Foreman Proxy Realm AD plugin
#
# This class installs the realm active directory plugin
#
# === Parameters:
#
# $realm::                 Name of the realm that should be managed
#
# $domain_controller::     FQDN of the Domain Controller
#
# $ou::                    OU where the machine account shall be placed
#
# $computername_prefix:: Prefix for the computername
#
# $computername_hash::     Generate the computername by calculating the SHA256 hexdigest of the hostname
#
# $computername_use_fqdn:: use the fqdn of the host to generate the computername
#
# === Advanced parameters:
#
# $version::                 plugin package version, it's passed to ensure parameter of package resource
#                            can be set to specific version number, 'latest', 'present' etc.
#
class foreman_proxy::plugin::realm::ad (
  String $realm = undef,
  Optional[String] $domain_controller = undef,
  Optional[String] $ou = undef,
  Optional[String] $computername_prefix = undef,
  Optional[Boolean] $computername_hash = undef,
  Optional[Boolean] $computername_use_fqdn = undef,
  Optional[String] $version = undef,
) {
  include foreman_proxy::params

  foreman_proxy::plugin::provider { 'realm_ad':
    package => "${foreman_proxy::params::plugin_prefix}realm_ad_plugin",
    version => $version,
  }
}
