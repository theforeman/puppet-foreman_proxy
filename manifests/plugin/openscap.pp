# = Foreman Proxy OpenSCAP plugin
#
# This class installs OpenSCAP plugin
#
# === Parameters:
#
# $enabled::                    enables/disables the plugin
#                               type:boolean
# $openscap_send_log_file::     Log file for the forwarding script
#
# $spooldir::                   Directory where OpenSCAP audits are stored
#                               before they are forwarded to Foreman
class foreman_proxy::plugin::openscap (
  $enabled                = $::foreman_proxy::plugin::openscap::params::enabled,
  $openscap_send_log_file = $::foreman_proxy::plugin::openscap::params::openscap_send_log_file,
  $spooldir               = $::foreman_proxy::plugin::openscap::params::spooldir,
) inherits foreman_proxy::plugin::openscap::params {
  validate_bool($enabled)
  validate_absolute_path($spooldir)
  validate_absolute_path($openscap_send_log_file)

  foreman_proxy::plugin { 'openscap': } ->
  foreman_proxy::settings_file { 'openscap':
    template_path => 'foreman_proxy/plugin/openscap.yml.erb',
  }
}
