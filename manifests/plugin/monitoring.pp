# = Foreman Proxy Monitoring plugin
#
# This class installs the monitoring plugin
#
# === Parameters:
#
# $provider::           monitoring provider
#                       type:String
#
# === Advanced parameters:
#
# $enabled::            enables/disables the monitoring plugin
#                       type:Boolean
#
# $group::              owner of plugin configuration
#                       type:Optional[String]
#
# $listen_on::          proxy feature listens on http, https, or both
#                       type:Foreman_proxy::ListenOn
#
# $version::            plugin package version, it's passed to ensure parameter of package resource
#                       can be set to specific version number, 'latest', 'present' etc.
#                       type:Optional[String]
#
class foreman_proxy::plugin::monitoring (
  $enabled            = $::foreman_proxy::plugin::monitoring::params::enabled,
  $group              = $::foreman_proxy::plugin::monitoring::params::group,
  $listen_on          = $::foreman_proxy::plugin::monitoring::params::listen_on,
  $provider           = $::foreman_proxy::plugin::monitoring::params::provider,
  $version            = $::foreman_proxy::plugin::monitoring::params::version,
) inherits foreman_proxy::plugin::monitoring::params {
  validate_bool($enabled)
  validate_listen_on($listen_on)
  validate_string($provider)

  foreman_proxy::plugin { 'monitoring':
    version => $version,
  }
  -> foreman_proxy::settings_file { 'monitoring':
    template_path => 'foreman_proxy/plugin/monitoring.yml.erb',
    group         => $group,
    enabled       => $enabled,
    listen_on     => $listen_on,
  }
}
