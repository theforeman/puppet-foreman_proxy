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
# $listen_on::          proxy feature listens on http, https, or both
#
# $version::            plugin package version, it's passed to ensure parameter of package resource
#                       can be set to specific version number, 'latest', 'present' etc.
#
class foreman_proxy::plugin::monitoring (
  Boolean $enabled = true,
  Foreman_proxy::ListenOn $listen_on = 'https',
  Array[String] $providers = ['icinga2'],
  Optional[String] $version = undef,
  Boolean $collect_status = true,
) {
  foreman_proxy::plugin::module { 'monitoring':
    version   => $version,
    enabled   => $enabled,
    listen_on => $listen_on,
  }
}
