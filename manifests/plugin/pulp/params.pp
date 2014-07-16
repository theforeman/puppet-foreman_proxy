class foreman_proxy::plugin::pulp::params {
  $enabled  = true
  $group     = $::foreman_proxy::user
  $pulp_url = "https://${::fqdn}/pulp"
}
