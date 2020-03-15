# Default parameters for the Chef smart proxy plugin
# @api private
class foreman_proxy::plugin::chef::params {
  include ::foreman_proxy::params

  $enabled      = true
  $listen_on    = 'https'
  $version      = undef
  $server_url   = "https://${::fqdn}"
  $client_name  = $::fqdn
  $private_key  = "${foreman_proxy::params::etc}/chef/client.pem"
  $ssl_verify   = true
  $ssl_pem_file = undef
}
