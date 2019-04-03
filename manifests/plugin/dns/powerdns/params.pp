# PowerDNS plugin defaults
# @api private
class foreman_proxy::plugin::dns::powerdns::params {
  $backend               = 'mysql'
  $mysql_hostname        = 'localhost'
  $mysql_username        = 'pdns'
  $mysql_password        = extlib::cache_data('foreman_cache_data', 'smart_proxy_dns_powerdns_password', extlib::random_password(16))
  $mysql_database        = 'pdns'
  $postgresql_connection = '' # lint:ignore:empty_string_assignment
  $rest_url              = 'http://localhost:8081/api/v1/servers/localhost'
  $rest_api_key          = '' # lint:ignore:empty_string_assignment
  $manage_database       = false
  $pdnssec               = 'pdnssec'
}
