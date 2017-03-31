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
  Boolean $enabled                    = $::foreman_proxy::plugin::monitoring::params::enabled,
  Optional[String] $group             = $::foreman_proxy::plugin::monitoring::params::group,
  Foreman_proxy::ListenOn $listen_on  = $::foreman_proxy::plugin::monitoring::params::listen_on,
  String $provider                    = $::foreman_proxy::plugin::monitoring::params::provider,
  Optional[String] $version           = $::foreman_proxy::plugin::monitoring::params::version,
) inherits foreman_proxy::plugin::monitoring::params {

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
