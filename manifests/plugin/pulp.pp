# = Foreman Proxy Pulp plugin
#
# This class installs pulp plugin
#
# === Parameters:
#
# $group::            group owner of the configuration file
#
# $enabled::          enables/disables the pulp plugin
#                     type:boolean
#
# $pulpnode_enabled:: enables/disables the pulpnode plugin
#                     type:boolean
#
# $pulp_url::         pulp url to use
#
class foreman_proxy::plugin::pulp (
  $enabled          = $::foreman_proxy::plugin::pulp::params::enabled,
  $pulpnode_enabled = $::foreman_proxy::plugin::pulp::params::pulpnode_enabled,
  $group            = $::foreman_proxy::plugin::pulp::params::group,
  $pulp_url         = $::foreman_proxy::plugin::pulp::params::pulp_url,
) inherits foreman_proxy::plugin::pulp::params {

  validate_bool($enabled)
  validate_bool($pulpnode_enabled)

  foreman_proxy::plugin {'pulp':
  } ->
  foreman_proxy::settings_file { 'pulp':
    template_path => 'foreman_proxy/plugin/pulp.yml.erb',
    group         => $group,
  } ->
  foreman_proxy::settings_file { 'pulpnode':
    template_path => 'foreman_proxy/plugin/pulpnode.yml.erb',
    group         => $group,
  }
}

