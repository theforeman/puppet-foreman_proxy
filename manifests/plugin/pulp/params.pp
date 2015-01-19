# Default parameters for the Pulp smart proxy plugin
class foreman_proxy::plugin::pulp::params {
  $enabled          = true
  $group            = undef
  $pulpnode_enabled = false
  $pulp_url         = "https://${::fqdn}/pulp"
}
