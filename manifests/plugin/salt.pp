# = Foreman Proxy Salt plugin
#
# This class installs Salt support for Foreman proxy
#
# === Parameters:
#
# $autosign_file::   File to use for salt autosign
#
# $user::            User to run salt commands under
#
# $api::             Use Salt API
#
# $api_url::         Salt API URL
#
# $api_auth::        Salt API auth mechanism
#
# $api_username::    Salt API username
#
# $api_password::    Salt API password
#
# $saltfile::        Path to Saltfile
#
# === Advanced parameters:
#
# $enabled::         Enables/disables the salt plugin
#
# $group::           Owner of plugin configuration
#
# $listen_on::       Proxy feature listens on https, http, or both
#
class foreman_proxy::plugin::salt (
  Stdlib::Absolutepath $autosign_file = $::foreman_proxy::plugin::salt::params::autosign_file,
  Boolean $enabled = $::foreman_proxy::plugin::salt::params::enabled,
  Foreman_proxy::ListenOn $listen_on = $::foreman_proxy::plugin::salt::params::listen_on,
  String $user = $::foreman_proxy::plugin::salt::params::user,
  Optional[String] $group = $::foreman_proxy::plugin::salt::params::group,
  Boolean $api = $::foreman_proxy::plugin::salt::params::api,
  Stdlib::HTTPUrl $api_url = $::foreman_proxy::plugin::salt::params::api_url,
  String $api_auth = $::foreman_proxy::plugin::salt::params::api_auth,
  String $api_username = $::foreman_proxy::plugin::salt::params::api_username,
  String $api_password = $::foreman_proxy::plugin::salt::params::api_password,
  Optional[Stdlib::Absolutepath] $saltfile = $::foreman_proxy::plugin::salt::params::saltfile,
) inherits foreman_proxy::plugin::salt::params {
  foreman_proxy::plugin { 'salt':
  }
  -> foreman_proxy::settings_file { 'salt':
    enabled       => $enabled,
    listen_on     => $listen_on,
    template_path => 'foreman_proxy/plugin/salt.yml.erb',
    group         => $group,
    feature       => 'Salt',
  }
}
