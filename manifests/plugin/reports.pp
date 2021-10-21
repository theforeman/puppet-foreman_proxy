# = Foreman Proxy Reports plugin
#
# This class installs the Reports plugin
#
# === Parameters:
#
# $keep_reports::             Keep sent reports in spool_dir directory
#                             when enabled, move files from the place on
#                             a regular basis (e.g. via cronjob).
#
# === Advanced parameters:
#
# $proxy_name::               Proxy hostname to appear in reports JSON
#
# $spool_dir::                Spool directory with processed reports
#
# $enabled::                  enables/disables the reports plugin
#
# $listen_on::                proxy feature listens on http, https, or both
#
# $version::                  plugin package version, it's passed to ensure parameter of package resource
#                             can be set to specific version number, 'latest', 'present' etc.
#
class foreman_proxy::plugin::reports (
  Optional[String] $proxy_name = undef,
  Stdlib::Absolutepath $spool_dir = '/var/lib/foreman-proxy/reports',
  Boolean $keep_reports = false,
  Boolean $enabled = true,
  Foreman_proxy::ListenOn $listen_on = 'https',
  Optional[String] $version = undef,
) {
  $reported_proxy_hostname = pick($proxy_name, $foreman_proxy::registered_name)

  foreman_proxy::plugin::module { 'reports':
    enabled   => $enabled,
    feature   => 'Reports',
    listen_on => $listen_on,
    version   => $version,
  }
}
