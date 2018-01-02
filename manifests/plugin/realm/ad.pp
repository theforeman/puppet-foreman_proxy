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
# $group::                  owner of plugin configuration
#
# $version::                 plugin package version, it's passed to ensure parameter of package resource
#                            can be set to specific version number, 'latest', 'present' etc.
#
class foreman_proxy::plugin::realm::ad (
  String $realm = $::foreman_proxy::plugin::realm::ad::params::realm,
  String $domain_controller = $::foreman_proxy::plugin::realm::ad::params::domain_controller,
  Optional[String] $ou = $::foreman_proxy::plugin::realm::ad::params::ou,
  Optional[String] $computername_prefix = $::foreman_proxy::plugin::realm::ad::params::computername_prefix,
  Optional[Boolean] $computername_hash = $::foreman_proxy::plugin::realm::ad::params::computername_hash,
  Optional[Boolean] $computername_use_fqdn = $::foreman_proxy::plugin::realm::ad::params::computername_use_fqdn,
  Optional[String] $group = $::foreman_proxy::plugin::realm::ad::params::group,
  Optional[String] $version = $::foreman_proxy::plugin::realm::ad::params::version,
) inherits foreman_proxy::plugin::realm::ad::params {
  foreman_proxy::plugin { 'realm_ad_plugin':
    version => $version,
  }
  -> foreman_proxy::settings_file { 'realm_ad':
    module        => false,
    template_path => 'foreman_proxy/plugin/realm_ad.yml.erb',
    group         => $group,
  }
}
