# Default parameters for the Chef smart proxy plugin
class foreman_proxy::plugin::chef::params {
  $enabled      = true
  $group        = undef
  $listen_on    = 'https'
  $version      = undef
  $server_url   = "https://${::fqdn}"
  $client_name  = $::fqdn
  $private_key  = '/etc/chef/client.pem'
  $ssl_verify   = true
  $ssl_pem_file = undef
}
