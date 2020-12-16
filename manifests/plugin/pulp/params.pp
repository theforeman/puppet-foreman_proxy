# Default parameters for the Pulp smart proxy plugin
# @api private
class foreman_proxy::plugin::pulp::params {
  $pulpcore_api_url     = "https://${facts['networking']['fqdn']}"
  $pulpcore_content_url = "${pulpcore_api_url}/pulp/content"
}
