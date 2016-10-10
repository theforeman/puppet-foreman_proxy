# Default parameters for the Omaha smart proxy plugin
class foreman_proxy::plugin::omaha::params {
  $enabled       = true
  $group         = undef
  $listen_on     = 'https'
  $contentpath   = '/var/lib/foreman-proxy/omaha/content'
  $sync_releases = 2
  $http_proxy    = undef
  $version       = undef
}
