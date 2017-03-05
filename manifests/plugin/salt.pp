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
  Stdlib::Absolutepath $autosign_file = $::foreman_proxy::plugin::salt::params::autosign_file,
  Boolean $enabled                    = $::foreman_proxy::plugin::salt::params::enabled,
  Foreman_proxy::ListenOn $listen_on  = $::foreman_proxy::plugin::salt::params::listen_on,
  String $user                        = $::foreman_proxy::plugin::salt::params::user,
  Optional[String] $group             = $::foreman_proxy::plugin::salt::params::group,
  Boolean $api                        = $::foreman_proxy::plugin::salt::params::api,
  Stdlib::HTTPUrl $api_url            = $::foreman_proxy::plugin::salt::params::api_url,
  String $api_auth                    = $::foreman_proxy::plugin::salt::params::api_auth,
  String $api_username                = $::foreman_proxy::plugin::salt::params::api_username,
  String $api_password                = $::foreman_proxy::plugin::salt::params::api_password,
) inherits foreman_proxy::plugin::salt::params {

  foreman_proxy::plugin { 'salt':
  } ->
  foreman_proxy::settings_file { 'salt':
    enabled       => $enabled,
    listen_on     => $listen_on,
    template_path => 'foreman_proxy/plugin/salt.yml.erb',
    group         => $group,
  }
}
