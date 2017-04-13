# = Foreman Proxy Monitoring plugin
#
# This class installs the monitoring plugin
#
# === Parameters:
#
# $providers::           monitoring providers
#
# $collect_status::      collect monitoring status from monitoring solution
#
# === Advanced parameters:
#
# $enabled::            enables/disables the monitoring plugin
#
# $group::              owner of plugin configuration
#
# $listen_on::          proxy feature listens on http, https, or both
#
# $version::            plugin package version, it's passed to ensure parameter of package resource
#                       can be set to specific version number, 'latest', 'present' etc.
#
class foreman_proxy::plugin::monitoring (
  Boolean $enabled = $::foreman_proxy::plugin::monitoring::params::enabled,
  Optional[String] $group = $::foreman_proxy::plugin::monitoring::params::group,
  Foreman_proxy::ListenOn $listen_on = $::foreman_proxy::plugin::monitoring::params::listen_on,
  Array[String] $providers = $::foreman_proxy::plugin::monitoring::params::providers,
  Optional[String] $version = $::foreman_proxy::plugin::monitoring::params::version,
  Boolean $collect_status = $::foreman_proxy::plugin::monitoring::params::collect_status,
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
