# @summary Defaults for the icingadirector provider to the monitoring plugin
# @api private
class foreman_proxy::plugin::monitoring::icingadirector::params {
  $enabled = true
  $director_url = "https://${::fqdn}/icingaweb2/director"
  $director_cacert = '/etc/foreman-proxy/monitoring/ca.crt'
  $director_user = undef
  $director_password = undef
  $verify_ssl = true
}
