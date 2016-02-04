# = Foreman Proxy Dynflow plugin
#
# This class installs Dynflow support for Foreman proxy
#
# === Parameters:
#
# $enabled::         Enables/disables the plugin
#                    type:boolean
#
# $listen_on::       Proxy feature listens on https, http, or both
#
# $database_path::   Path to the SQLite database file
#
# $console_auth::    Whether to enable trusted hosts and ssl for the dynflow console
#                    type:boolean
#
class foreman_proxy::plugin::dynflow (
  $enabled           = $::foreman_proxy::plugin::dynflow::params::enabled,
  $listen_on         = $::foreman_proxy::plugin::dynflow::params::listen_on,
  $database_path     = $::foreman_proxy::plugin::dynflow::params::database_path,
  $console_auth      = $::foreman_proxy::plugin::dynflow::params::console_auth,
) inherits foreman_proxy::plugin::dynflow::params {

  validate_bool($enabled, $console_auth)
  validate_listen_on($listen_on)
  validate_absolute_path($database_path)

  foreman_proxy::plugin { 'dynflow':
  } ->
  foreman_proxy::settings_file { 'dynflow':
    enabled       => $enabled,
    listen_on     => $listen_on,
    template_path => 'foreman_proxy/plugin/dynflow.yml.erb',
  }
}
