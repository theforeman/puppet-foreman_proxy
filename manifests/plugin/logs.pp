# = Foreman Proxy Abrt plugin
#
# This class configures Logs buffer module.
#
# === Parameters:
#
# $enabled::                    Enables/disables the plugin
#                               type:boolean
#
# $listen_on::                  Proxy feature listens on http, https, or both
#
class foreman_proxy::plugin::logs (
  $enabled                 = $::foreman_proxy::plugin::logs::params::enabled,
  $listen_on               = $::foreman_proxy::plugin::logs::params::listen_on,
) inherits foreman_proxy::plugin::logs::params {

  validate_bool($enabled)
  validate_listen_on($listen_on)

  foreman_proxy::plugin { 'logs':
  } ->
  foreman_proxy::settings_file { 'logs':
    template_path => 'foreman_proxy/plugin/logs.yml.erb',
    group         => $group,
    listen_on     => $listen_on,
    enabled       => $enabled,
  }
}
