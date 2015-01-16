# = Foreman Proxy Pulp plugin
#
# This class installs pulp plugin
#
# === Parameters:
#
# $group::            group owner of the configuration file
#
# $version::          plugin package version, it's passed to ensure parameter of package resource
#                     can be set to specific version number, 'latest', 'present' etc.
#
# $enabled::          enables/disables the pulp plugin
#                     type:boolean
#
# $listen_on::        Proxy feature listens on http, https, or both
#
# $pulpnode_enabled:: enables/disables the pulpnode plugin
#                     type:boolean
#
# $pulp_url::         pulp url to use
#
class foreman_proxy::plugin::pulp (
  $enabled          = $::foreman_proxy::plugin::pulp::params::enabled,
  $listen_on        = $::foreman_proxy::plugin::pulp::params::listen_on,
  $pulpnode_enabled = $::foreman_proxy::plugin::pulp::params::pulpnode_enabled,
  $version          = $::foreman_proxy::plugin::pulp::params::version,
  $group            = $::foreman_proxy::plugin::pulp::params::group,
  $pulp_url         = $::foreman_proxy::plugin::pulp::params::pulp_url,
) inherits foreman_proxy::plugin::pulp::params {

  validate_bool($enabled)
  validate_bool($pulpnode_enabled)

  foreman_proxy::plugin {'pulp':
    version => $version,
  } ->
  foreman_proxy::settings_file { 'pulp':
    template_path => 'foreman_proxy/plugin/pulp.yml.erb',
    group         => $group,
    enabled       => $enabled,
    listen_on     => $listen_on,
  } ->
  foreman_proxy::settings_file { 'pulpnode':
    template_path => 'foreman_proxy/plugin/pulpnode.yml.erb',
    group         => $group,
    enabled       => $pulpnode_enabled,
    listen_on     => $listen_on,
  }
}
