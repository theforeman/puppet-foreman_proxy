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
# $group::                      group owner of the configuration file
#
# $listen_on::                  Proxy feature listens on http, https, or both
#
# $version::                    plugin package version, it's passed to ensure parameter of package resource
#                               can be set to specific version number, 'latest', 'present' etc.
#
class foreman_proxy::plugin::abrt (
  Boolean $enabled = $::foreman_proxy::plugin::abrt::params::enabled,
  Foreman_proxy::ListenOn $listen_on = $::foreman_proxy::plugin::abrt::params::listen_on,
  Optional[String] $version = $::foreman_proxy::plugin::abrt::params::version,
  Optional[String] $group = $::foreman_proxy::plugin::abrt::params::group,
  Stdlib::Absolutepath $abrt_send_log_file = $::foreman_proxy::plugin::abrt::params::abrt_send_log_file,
  Stdlib::Absolutepath $spooldir = $::foreman_proxy::plugin::abrt::params::spooldir,
  Boolean $aggregate_reports = $::foreman_proxy::plugin::abrt::params::aggregate_reports,
  Integer[0] $send_period = $::foreman_proxy::plugin::abrt::params::send_period,
  Optional[String] $faf_server_url = $::foreman_proxy::plugin::abrt::params::faf_server_url,
  Boolean $faf_server_ssl_noverify = $::foreman_proxy::plugin::abrt::params::faf_server_ssl_noverify,
  Optional[Stdlib::Absolutepath] $faf_server_ssl_cert = $::foreman_proxy::plugin::abrt::params::faf_server_ssl_cert,
  Optional[Stdlib::Absolutepath] $faf_server_ssl_key = $::foreman_proxy::plugin::abrt::params::faf_server_ssl_key,
) inherits foreman_proxy::plugin::abrt::params {
  foreman_proxy::plugin { 'abrt':
    version => $version,
  }
  -> foreman_proxy::settings_file { 'abrt':
    template_path => 'foreman_proxy/plugin/abrt.yml.erb',
    feature       => 'Abrt',
    group         => $group,
    listen_on     => $listen_on,
    enabled       => $enabled,
  }
}
