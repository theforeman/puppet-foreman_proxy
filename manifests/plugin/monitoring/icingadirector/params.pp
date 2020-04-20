# @summary Defaults for the icingadirector provider to the monitoring plugin
# @api private
class foreman_proxy::plugin::monitoring::icingadirector::params {
  include foreman_proxy::params

  $enabled = true
  $director_url = "https://${facts['networking']['fqdn']}/icingaweb2/director"
  $director_cacert = "${foreman_proxy::params::config_dir}/monitoring/ca.crt"
  $director_user = undef
  $director_password = undef
  $verify_ssl = true
}
