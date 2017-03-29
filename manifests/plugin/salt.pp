# = Foreman Proxy Salt plugin
#
# This class installs Salt support for Foreman proxy
#
# === Parameters:
#
# $autosign_file::   File to use for salt autosign
#                    type:Stdlib::Absolutepath
#
# $user::            User to run salt commands under
#                    type:String
#
# $api::             Use Salt API
#                    type:Boolean
#
# $api_url::         Salt API URL
#                    type:Stdlib::HTTPUrl
#
# $api_auth::        Salt API auth mechanism
#                    type:String
#
# $api_username::    Salt API username
#                    type:String
#
# $api_password::    Salt API password
#                    type:String
#
# === Advanced parameters:
#
# $enabled::         Enables/disables the salt plugin
#                    type:Boolean
#
# $group::           Owner of plugin configuration
#                    type:Optional[String]
#
# $listen_on::       Proxy feature listens on https, http, or both
#                    type:Foreman_proxy::ListenOn
#
class foreman_proxy::plugin::salt (
  $autosign_file     = $::foreman_proxy::plugin::salt::params::autosign_file,
  $enabled           = $::foreman_proxy::plugin::salt::params::enabled,
  $listen_on         = $::foreman_proxy::plugin::salt::params::listen_on,
  $user              = $::foreman_proxy::plugin::salt::params::user,
  $group             = $::foreman_proxy::plugin::salt::params::group,
  $api               = $::foreman_proxy::plugin::salt::params::api,
  $api_url           = $::foreman_proxy::plugin::salt::params::api_url,
  $api_auth          = $::foreman_proxy::plugin::salt::params::api_auth,
  $api_username      = $::foreman_proxy::plugin::salt::params::api_username,
  $api_password      = $::foreman_proxy::plugin::salt::params::api_password,
) inherits foreman_proxy::plugin::salt::params {

  validate_bool($enabled, $api)
  validate_listen_on($listen_on)
  validate_absolute_path($autosign_file)
  validate_string($user)

  if $api {
    validate_string($api_url, $api_auth, $api_username, $api_password)
  }

  if $group {
    validate_string($group)
  }

  foreman_proxy::plugin { 'salt':
  }
  -> foreman_proxy::settings_file { 'salt':
    enabled       => $enabled,
    listen_on     => $listen_on,
    template_path => 'foreman_proxy/plugin/salt.yml.erb',
    group         => $group,
  }
}
