# = Foreman Proxy OpenSCAP plugin
#
# This class installs OpenSCAP plugin
#
# === Parameters:
#
# $openscap_send_log_file::     Log file for the forwarding script
#
# $spooldir::                   Directory where OpenSCAP audits are stored
#                               before they are forwarded to Foreman
#
# $contentdir::                 Directory where OpenSCAP content XML are stored
#                               So we will not request the XML from Foreman each time
#
# $reportsdir::                 Directory where OpenSCAP report XML are stored
#                               So Foreman can request arf xml reports
#
# $failed_dir::                 Directory where OpenSCAP report XML are stored
#                               In case sending to Foreman succeeded, yet failed to save to reportsdir
#
# $corrupted_dir::              Directory where corrupted OpenSCAP report XML are stored
#
# $proxy_name::                 Proxy name to send to Foreman with parsed report
#                               Foreman matches it against names of registered proxies to find the report source
#
# $timeout::                    Timeout for sending ARF reports to foreman
#
# === Advanced parameters:
#
# $enabled::                    enables/disables the openscap plugin
#
# $listen_on::                  Proxy feature listens on http, https, or both
#
# $version::                    plugin package version, it's passed to ensure parameter of package resource
#                               can be set to specific version number, 'latest', 'present' etc.
#
class foreman_proxy::plugin::openscap (
  Boolean $enabled = true,
  Optional[String] $version = undef,
  Foreman_proxy::ListenOn $listen_on = 'https',
  Stdlib::Absolutepath $openscap_send_log_file = '/var/log/foreman-proxy/openscap-send.log',
  Stdlib::Absolutepath $spooldir = '/var/spool/foreman-proxy/openscap',
  Stdlib::Absolutepath $contentdir = '/var/lib/foreman-proxy/openscap/content',
  Stdlib::Absolutepath $reportsdir = '/var/lib/foreman-proxy/openscap/reports',
  Stdlib::Absolutepath $failed_dir = '/var/lib/foreman-proxy/openscap/failed',
  Stdlib::Absolutepath $corrupted_dir = '/var/lib/foreman-proxy/openscap/corrupted',
  Optional[String] $proxy_name = undef,
  Integer[0] $timeout = 60,
) {
  $registered_proxy_name = pick($proxy_name, $foreman_proxy::registered_name)
  foreman_proxy::plugin::module { 'openscap':
    version   => $version,
    listen_on => $listen_on,
    enabled   => $enabled,
  }
}
