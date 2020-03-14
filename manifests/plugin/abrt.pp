# = Foreman Proxy Abrt plugin
#
# This class installs abrt plugin
#
# === Parameters:
#
# $abrt_send_log_file::         Log file for the forwarding script.
#
# $spooldir::                   Directory where uReports are stored before they are sent
#
# $aggregate_reports::          Merge duplicate reports before sending
#
# $send_period::                Period (in seconds) after which collected reports are forwarded.
#                               Meaningful only if smart-proxy-abrt-send is run as a daemon (not from cron).
#
# $faf_server_url::             FAF server instance the reports will be forwarded to
#
# $faf_server_ssl_noverify::    Set to true if FAF server uses self-signed certificate
#
# $faf_server_ssl_cert::        Enable client authentication to FAF server: set ssl certificate
#
# $faf_server_ssl_key::         Enable client authentication to FAF server: set ssl key
#
# === Advanced parameters:
#
# $enabled::                    Enables/disables the abrt plugin
#
# $listen_on::                  Proxy feature listens on http, https, or both
#
# $version::                    plugin package version, it's passed to ensure parameter of package resource
#                               can be set to specific version number, 'latest', 'present' etc.
#
class foreman_proxy::plugin::abrt (
  Boolean $enabled = true,
  Foreman_proxy::ListenOn $listen_on = 'https',
  Optional[String] $version = undef,
  Stdlib::Absolutepath $abrt_send_log_file = '/var/log/foreman-proxy/abrt-send.log',
  Stdlib::Absolutepath $spooldir = '/var/spool/foreman-proxy-abrt',
  Boolean $aggregate_reports = true,
  Integer[0] $send_period = 600,
  Optional[String] $faf_server_url = undef,
  Boolean $faf_server_ssl_noverify = true,
  Optional[Stdlib::Absolutepath] $faf_server_ssl_cert = undef,
  Optional[Stdlib::Absolutepath] $faf_server_ssl_key = undef,
) {
  foreman_proxy::plugin::module { 'abrt':
    version   => $version,
    listen_on => $listen_on,
    enabled   => $enabled,
  }
}
