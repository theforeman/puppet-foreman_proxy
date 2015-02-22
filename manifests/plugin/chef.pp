# = Foreman Proxy Chef plugin
#
# This class installs chef plugin
#
# === Parameters:
#
# $group::        group owner of the configuration file
#
# $version::      plugin package version, it's passed to ensure parameter of package resource
#                 can be set to specific version number, 'latest', 'present' etc.
#
# $enabled::      enables/disables the plugin
#
# $listen_on::    Proxy feature listens on http, https, or both
#
# $server_url::   chef server url
#
# $client_name::  chef client name used for authentication of other client requests
#
# $private_key::  path to file containing private key for $client_name client
#
# $ssl_verify::   should we perform chef server ssl cert verification? this requires
#                 CA certificate installed and trusted
#                 type:boolean
#
# $ssl_pem_file:: if $ssl_verify is true you can specify a path to a file which
#                 contains certificate and related private key if the certificate
#                 is not globally trusted
#
class foreman_proxy::plugin::chef (
  $enabled      = $::foreman_proxy::plugin::chef::params::enabled,
  $listen_on    = $::foreman_proxy::plugin::chef::params::listen_on,
  $version      = $::foreman_proxy::plugin::chef::params::version,
  $group        = $::foreman_proxy::plugin::chef::params::group,
  $server_url   = $::foreman_proxy::plugin::chef::params::server_url,
  $client_name  = $::foreman_proxy::plugin::chef::params::client_name,
  $private_key  = $::foreman_proxy::plugin::chef::params::private_key,
  $ssl_verify   = $::foreman_proxy::plugin::chef::params::ssl_verify,
  $ssl_pem_file = $::foreman_proxy::plugin::chef::params::ssl_pem_file,
) inherits foreman_proxy::plugin::chef::params {

  validate_bool($enabled)
  validate_listen_on($listen_on)

  foreman_proxy::plugin {'chef':
    version => $version,
  } ->
  foreman_proxy::settings_file { 'chef':
    listen_on     => $listen_on,
    enabled       => $enabled,
    group         => $group,
    template_path => 'foreman_proxy/plugin/chef.yml.erb',
  }
}
