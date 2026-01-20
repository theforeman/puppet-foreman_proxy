# = Foreman Proxy Salt plugin
#
# This class installs Salt support for Foreman proxy
#
# === Parameters:
#
# $autosign_file::   File to use for salt autosign
#
# $autosign_key_file:: File to use for salt autosign via grains
#
# $minimum_auth_version:: Minimum authentication version for salt minions
#
# $user::            User to run salt commands under
#
# $group::           Group to run salt commands and access configuration files
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
# $api_interfaces::  Salt API interfaces
#
# $saltfile::        Path to Saltfile
#
# === Advanced parameters:
#
# $enabled::         Enables/disables the salt plugin
#
# $listen_on::       Proxy feature listens on https, http, or both
#
class foreman_proxy::plugin::salt (
  Stdlib::Absolutepath $autosign_file = $foreman_proxy::plugin::salt::params::autosign_file,
  Stdlib::Absolutepath $autosign_key_file = $foreman_proxy::plugin::salt::params::autosign_key_file,
  Optional[Integer] $minimum_auth_version = $foreman_proxy::plugin::salt::params::minimum_auth_version,
  Boolean $enabled = $foreman_proxy::plugin::salt::params::enabled,
  Foreman_proxy::ListenOn $listen_on = $foreman_proxy::plugin::salt::params::listen_on,
  String $user = $foreman_proxy::plugin::salt::params::user,
  Optional[String[1]] $group = undef,
  Boolean $api = $foreman_proxy::plugin::salt::params::api,
  Stdlib::HTTPUrl $api_url = $foreman_proxy::plugin::salt::params::api_url,
  String $api_auth = $foreman_proxy::plugin::salt::params::api_auth,
  String $api_username = $foreman_proxy::plugin::salt::params::api_username,
  String $api_password = $foreman_proxy::plugin::salt::params::api_password,
  Array[String] $api_interfaces = $foreman_proxy::plugin::salt::params::api_interfaces,
  Optional[Stdlib::Absolutepath] $saltfile = $foreman_proxy::plugin::salt::params::saltfile,
) inherits foreman_proxy::plugin::salt::params {
  $foreman_ssl_cert = pick($foreman_proxy::foreman_ssl_cert, $foreman_proxy::ssl_cert)
  $foreman_ssl_key = pick($foreman_proxy::foreman_ssl_key, $foreman_proxy::ssl_key)
  $reactor_path = '/usr/share/foreman-proxy/salt/reactors'

  foreman_proxy::plugin::module { 'salt':
    enabled   => $enabled,
    listen_on => $listen_on,
  }
  ~> file { "${foreman_proxy::etc}/salt/master.d/foreman.conf":
    ensure  => file,
    content => template('foreman_proxy/plugin/salt_master.conf.erb'),
    owner   => pick($user, $foreman_proxy::user),
    group   => pick($group, $foreman_proxy::user),
    mode    => '0640',
  }
}
