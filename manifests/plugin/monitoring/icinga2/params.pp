class foreman_proxy::plugin::monitoring::icinga2::params {
  $enabled = true
  $server = $::fqdn
  $api_cacert = '/etc/foreman-proxy/monitoring/ca.crt'
  $api_user = 'foreman'
  $api_usercert = '/etc/foreman-proxy/monitoring/foreman.crt'
  $api_userkey = '/etc/foreman-proxy/monitoring/foreman.key'
  $api_password = undef
  $verify_ssl = true
}
