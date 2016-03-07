# = Foreman Proxy OpenSCAP plugin
#
# This class installs OpenSCAP plugin
#
# === Parameters:
#
# $version::                    plugin package version, it's passed to ensure parameter of package resource
#                               can be set to specific version number, 'latest', 'present' etc.
#
# $enabled::                    enables/disables the plugin
#                               type:boolean
#
# $listen_on::                  Proxy feature listens on http, https, or both
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
class foreman_proxy::plugin::openscap (
  $enabled                = $::foreman_proxy::plugin::openscap::params::enabled,
  $version                = $::foreman_proxy::plugin::openscap::params::version,
  $listen_on              = $::foreman_proxy::plugin::openscap::params::listen_on,
  $openscap_send_log_file = $::foreman_proxy::plugin::openscap::params::openscap_send_log_file,
  $spooldir               = $::foreman_proxy::plugin::openscap::params::spooldir,
  $contentdir             = $::foreman_proxy::plugin::openscap::params::contentdir,
  $reportsdir             = $::foreman_proxy::plugin::openscap::params::reportsdir,
  $failed_dir             = $::foreman_proxy::plugin::openscap::params::failed_dir,
) inherits foreman_proxy::plugin::openscap::params {
  validate_bool($enabled)
  validate_listen_on($listen_on)
  validate_absolute_path($spooldir)
  validate_absolute_path($openscap_send_log_file)
  validate_absolute_path($contentdir)
  validate_absolute_path($reportsdir)
  validate_absolute_path($failed_dir)

  foreman_proxy::plugin { 'openscap':
    version => $version,
  } ->
  foreman_proxy::settings_file { 'openscap':
    template_path => 'foreman_proxy/plugin/openscap.yml.erb',
    listen_on     => $listen_on,
    enabled       => $enabled,
  }
}
