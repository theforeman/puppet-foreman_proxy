# = Foreman Proxy Chef plugin
#
# This class installs chef plugin
#
# === Parameters:
#
# $server_url::   chef server url
#
# $client_name::  chef client name used for authentication of other client requests
#
# $private_key::  path to file containing private key for $client_name client
#
# $ssl_verify::   should we perform chef server ssl cert verification? this requires
#                 CA certificate installed and trusted
#
# $ssl_pem_file:: if $ssl_verify is true you can specify a path to a file which
#                 contains certificate and related private key if the certificate
#                 is not globally trusted
#
# === Advanced parameters:
#
# $enabled::      enables/disables the chef plugin
#
# $listen_on::    Proxy feature listens on http, https, or both
#
# $version::      plugin package version, it's passed to ensure parameter of package resource
#                 can be set to specific version number, 'latest', 'present' etc.
#
class foreman_proxy::plugin::chef (
  Boolean $enabled = $::foreman_proxy::plugin::chef::params::enabled,
  Foreman_proxy::ListenOn $listen_on = $::foreman_proxy::plugin::chef::params::listen_on,
  Optional[String] $version = $::foreman_proxy::plugin::chef::params::version,
  Stdlib::HTTPUrl $server_url = $::foreman_proxy::plugin::chef::params::server_url,
  String $client_name = $::foreman_proxy::plugin::chef::params::client_name,
  Stdlib::Absolutepath $private_key = $::foreman_proxy::plugin::chef::params::private_key,
  Boolean $ssl_verify = $::foreman_proxy::plugin::chef::params::ssl_verify,
  Optional[Stdlib::Absolutepath] $ssl_pem_file = $::foreman_proxy::plugin::chef::params::ssl_pem_file,
) inherits foreman_proxy::plugin::chef::params {
  foreman_proxy::plugin::module { 'chef':
    enabled   => $enabled,
    listen_on => $listen_on,
  }
}
