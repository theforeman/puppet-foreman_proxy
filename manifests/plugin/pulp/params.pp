# Default parameters for the Pulp smart proxy plugin
class foreman_proxy::plugin::pulp::params {
  $enabled          = true
  $listen_on        = 'https'
  $version          = undef
  $group            = undef
  $pulpnode_enabled = false
  $pulp_url         = "https://${::fqdn}/pulp"
  $pulp_dir         = '/var/lib/pulp'
  $pulp_content_dir = '/var/lib/pulp/content'
  $mongodb_dir      = '/var/lib/mongodb'
}
