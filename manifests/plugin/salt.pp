# = Foreman Proxy Salt plugin
#
# This class installs Salt support for Foreman proxy
#
# === Parameters:
#
# $enabled::         Enables/disables the plugin
#                    type:boolean
#
# $listen_on::       Proxy feature listens on https, http, or both
#
# $autosign_file::   File to use for salt autosign
#
# $user::            User to run salt commands under
#
# $group::           Owner of plugin configuration
#
class foreman_proxy::plugin::salt (
  $autosign_file     = $::foreman_proxy::plugin::salt::params::autosign_file,
  $enabled           = $::foreman_proxy::plugin::salt::params::enabled,
  $listen_on         = $::foreman_proxy::plugin::salt::params::listen_on,
  $user              = $::foreman_proxy::plugin::salt::params::user,
  $group             = $::foreman_proxy::plugin::salt::params::group,
) inherits foreman_proxy::plugin::salt::params {

  validate_bool($enabled)
  validate_listen_on($listen_on)
  validate_absolute_path($autosign_file)
  validate_string($user)

  if $group {
    validate_string($group)
  }

  foreman_proxy::plugin { 'salt':
  } ->
  foreman_proxy::settings_file { 'salt':
    enabled       => $enabled,
    listen_on     => $listen_on,
    template_path => 'foreman_proxy/plugin/salt.yml.erb',
    group         => $group,
  }
}
