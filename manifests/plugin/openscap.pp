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
  Boolean $enabled = $::foreman_proxy::plugin::openscap::params::enabled,
  Optional[String] $version = $::foreman_proxy::plugin::openscap::params::version,
  Foreman_proxy::ListenOn $listen_on = $::foreman_proxy::plugin::openscap::params::listen_on,
  Stdlib::Absolutepath $openscap_send_log_file = $::foreman_proxy::plugin::openscap::params::openscap_send_log_file,
  Stdlib::Absolutepath $spooldir = $::foreman_proxy::plugin::openscap::params::spooldir,
  Stdlib::Absolutepath $contentdir = $::foreman_proxy::plugin::openscap::params::contentdir,
  Stdlib::Absolutepath $reportsdir = $::foreman_proxy::plugin::openscap::params::reportsdir,
  Stdlib::Absolutepath $failed_dir = $::foreman_proxy::plugin::openscap::params::failed_dir,
  Optional[String] $proxy_name = $::foreman_proxy::plugin::openscap::params::proxy_name,
  Integer[0] $timeout = $::foreman_proxy::plugin::openscap::params::timeout,
) inherits foreman_proxy::plugin::openscap::params {
  $registered_proxy_name = pick($proxy_name, $foreman_proxy::registered_name)
  foreman_proxy::plugin { 'openscap':
    version => $version,
  }
  -> foreman_proxy::settings_file { 'openscap':
    template_path => 'foreman_proxy/plugin/openscap.yml.erb',
    listen_on     => $listen_on,
    enabled       => $enabled,
    feature       => 'Openscap',
  }
}
