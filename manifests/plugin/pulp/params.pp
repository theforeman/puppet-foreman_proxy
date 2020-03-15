# Default parameters for the Pulp smart proxy plugin
# @api private
class foreman_proxy::plugin::pulp::params {
  $enabled              = true
  $listen_on            = 'https'
  $version              = undef
  $pulpnode_enabled     = false
  $pulpcore_enabled     = false
  $pulpcore_mirror      = false
  $pulp_url             = "https://${::fqdn}/pulp"
  $pulpcore_api_url     = "https://${::fqdn}"
  $pulpcore_content_url = "${pulp_url}/content"
  $pulp_dir             = '/var/lib/pulp'
  $pulp_content_dir     = '/var/lib/pulp/content'
  $puppet_content_dir   = undef
  $mongodb_dir          = '/var/lib/mongodb'
}
