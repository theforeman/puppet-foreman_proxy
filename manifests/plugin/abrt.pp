# = Foreman Proxy Abrt plugin
#
# This class installs abrt plugin
#
# === Parameters:
#
# $group::                      group owner of the configuration file
#
# $version::                    plugin package version, it's passed to ensure parameter of package resource
#                               can be set to specific version number, 'latest', 'present' etc.
#
# $enabled::                    Enables/disables the plugin
#                               type:boolean
#
# $listen_on::                  Proxy feature listens on http, https, or both
#
# $abrt_send_log_file::         Log file for the forwarding script.
#
# $spooldir::                   Directory where uReports are stored before they are sent
#
# $aggregate_reports::          Merge duplicate reports before sending
#
# $send_period::                Period (in seconds) after which collected reports are forwarded.
#                               Meaningful only if smart-proxy-abrt-send is run as a daemon (not from cron).
#                               type:integer
#
# $faf_server_url::             FAF server instance the reports will be forwarded to
#
# $faf_server_ssl_noverify::    Set to true if FAF server uses self-signed certificate
#                               type:boolean
#
# $faf_server_ssl_cert::        Enable client authentication to FAF server: set ssl certificate
#
# $faf_server_ssl_key::         Enable client authentication to FAF server: set ssl key
#
class foreman_proxy::plugin::abrt (
  $enabled                 = $::foreman_proxy::plugin::abrt::params::enabled,
  $listen_on               = $::foreman_proxy::plugin::abrt::params::listen_on,
  $version                 = $::foreman_proxy::plugin::abrt::params::version,
  $group                   = $::foreman_proxy::plugin::abrt::params::group,
  $abrt_send_log_file      = $::foreman_proxy::plugin::abrt::params::abrt_send_log_file,
  $spooldir                = $::foreman_proxy::plugin::abrt::params::spooldir,
  $aggregate_reports       = $::foreman_proxy::plugin::abrt::params::aggregate_reports,
  $send_period             = $::foreman_proxy::plugin::abrt::params::send_period,
  $faf_server_url          = $::foreman_proxy::plugin::abrt::params::faf_server_url,
  $faf_server_ssl_noverify = $::foreman_proxy::plugin::abrt::params::faf_server_ssl_noverify,
  $faf_server_ssl_cert     = $::foreman_proxy::plugin::abrt::params::faf_server_ssl_cert,
  $faf_server_ssl_key      = $::foreman_proxy::plugin::abrt::params::faf_server_ssl_key,
) inherits foreman_proxy::plugin::abrt::params {

  validate_bool($enabled)
  validate_listen_on($listen_on)
  validate_absolute_path($abrt_send_log_file)
  validate_absolute_path($spooldir)
  validate_bool($aggregate_reports)
  validate_bool($faf_server_ssl_noverify)

  foreman_proxy::plugin { 'abrt':
    version => $version,
  } ->
  foreman_proxy::settings_file { 'abrt':
    template_path => 'foreman_proxy/plugin/abrt.yml.erb',
    group         => $group,
    listen_on     => $listen_on,
    enabled       => $enabled,
  }
}
