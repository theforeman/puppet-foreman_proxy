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
  Boolean $enabled = true,
  Optional[String] $group = undef,
  Foreman_proxy::ListenOn $listen_on = 'https',
  Array[String] $providers = ['icinga2'],
  Optional[String] $version = undef,
  Boolean $collect_status = true,
) {
  foreman_proxy::plugin { 'monitoring':
    version => $version,
  }
  -> foreman_proxy::settings_file { 'monitoring':
    template_path => 'foreman_proxy/plugin/monitoring.yml.erb',
    group         => $group,
    enabled       => $enabled,
    feature       => 'Monitoring',
    listen_on     => $listen_on,
  }
}
