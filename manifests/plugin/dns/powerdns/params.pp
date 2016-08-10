class foreman_proxy::plugin::dns::powerdns::params {
  $backend               = 'mysql'
  $mysql_hostname        = 'localhost'
  $mysql_username        = 'pdns'
  $mysql_password        = cache_data('foreman_cache_data', 'smart_proxy_dns_powerdns_password', random_password(16))
  $mysql_database        = 'pdns'
  $postgresql_connection = '' # lint:ignore:empty_string_assignment
  $manage_database       = false
  $pdnssec               = 'pdnssec'
}
