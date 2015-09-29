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
class foreman_proxy::plugin::dynflow (
  $enabled           = $::foreman_proxy::plugin::dynflow::params::enabled,
  $listen_on         = $::foreman_proxy::plugin::dynflow::params::listen_on,
) inherits foreman_proxy::plugin::dynflow::params {

  validate_bool($enabled)
  validate_listen_on($listen_on)

  foreman_proxy::plugin { 'dynflow':
  } ->
  foreman_proxy::settings_file { 'dynflow':
    enabled       => $enabled,
    listen_on     => $listen_on,
    template_path => 'foreman_proxy/plugin/dynflow.yml.erb',
  }
}
