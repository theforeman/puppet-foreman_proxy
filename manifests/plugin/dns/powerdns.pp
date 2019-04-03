# = Foreman Proxy PowerDNS DNS plugin
#
# This class installs the PowerDNS DNS plugin for Foreman proxy
#
# === Parameters:
#
# $backend::               The backend to select, either mysql or postgresql.
#
# $pdnssec::               pdnssec command to run rectify-zone with. Can be an
#                          empty string.
#
# === MySQL parameters:
#
# $manage_database::       Whether to manage the database. Only works for
#                          mysql. Includes the mysql server.
#
# $mysql_hostname::        MySQL server hostname. Only used when the backend is mysql.
#
# $mysql_username::        MySQL server username. Only used when the backend is mysql.
#
# $mysql_password::        MySQL server password. Only used when the backend is mysql.
#
# $mysql_database::        MySQL server database. Only used when the backend is mysql.
#
# === PostgreSQL parameters:
#
# $postgresql_connection:: The postgresql connection string.
#
# === REST parameters:
#
# $rest_url::              The REST API URL
#
# $rest_api_key::          The REST API key
#
class foreman_proxy::plugin::dns::powerdns (
  Enum['rest', 'mysql', 'postgresql'] $backend = $::foreman_proxy::plugin::dns::powerdns::params::backend,
  String $mysql_hostname = $::foreman_proxy::plugin::dns::powerdns::params::mysql_hostname,
  String $mysql_username = $::foreman_proxy::plugin::dns::powerdns::params::mysql_username,
  String $mysql_password = $::foreman_proxy::plugin::dns::powerdns::params::mysql_password,
  String $mysql_database = $::foreman_proxy::plugin::dns::powerdns::params::mysql_database,
  String $postgresql_connection = $::foreman_proxy::plugin::dns::powerdns::params::postgresql_connection,
  Stdlib::HTTPUrl $rest_url = $::foreman_proxy::plugin::dns::powerdns::params::rest_url,
  String $rest_api_key = $::foreman_proxy::plugin::dns::powerdns::params::rest_api_key,
  Boolean $manage_database = $::foreman_proxy::plugin::dns::powerdns::params::manage_database,
  String $pdnssec = $::foreman_proxy::plugin::dns::powerdns::params::pdnssec,
) inherits foreman_proxy::plugin::dns::powerdns::params {
  if $manage_database and $backend == 'mysql' {
    include ::mysql::server
    mysql::db { $mysql_database:
      user     => $mysql_username,
      password => $mysql_password,
      host     => $mysql_hostname,
      grant    => ['ALL'],
    }
  }

  foreman_proxy::plugin { 'dns_powerdns':
  }
  -> foreman_proxy::settings_file { 'dns_powerdns':
    module        => false,
    template_path => 'foreman_proxy/plugin/dns_powerdns.yml.erb',
  }
}
