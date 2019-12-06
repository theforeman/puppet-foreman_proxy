# Default parameters for the Pulp smart proxy plugin
class foreman_proxy::plugin::pulp::params {
  include ::foreman_proxy::params

  $enabled            = true
  $listen_on          = 'https'
  $version            = undef
  $group              = undef
  $pulpnode_enabled   = false
  $pulp3_enabled      = false
  $pulp3_mirror       = false
  $pulp_url           = "https://${::fqdn}/pulp"
  $pulp3_api_url      = "${pulp_url}/api"
  $pulp3_content_url  = "${pulp_url}/content"
  $pulp_dir           = '/var/lib/pulp'
  $pulp_content_dir   = '/var/lib/pulp/content'
  $puppet_content_dir = pick($::puppet_environmentpath, "${::foreman_proxy::params::puppetdir}/environments")
  $mongodb_dir        = '/var/lib/mongodb'
}
