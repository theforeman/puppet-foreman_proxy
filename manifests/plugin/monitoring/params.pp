# Default parameters for the Monitoring smart proxy plugin
class foreman_proxy::plugin::monitoring::params {
  $enabled   = true
  $group     = undef
  $listen_on = 'https'
  $provider  = 'icinga2'
  $version   = undef
}
