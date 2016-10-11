# = Foreman Proxy PowerDNS DNS plugin
#
# This class installs the PowerDNS DNS plugin for Foreman proxy
#
# === Parameters:
#
# $backend::               The backend to select, either mysql or postgresql.
#                          type:Enum['mysql', 'postgresql']
#
# $mysql_hostname::        MySQL server hostname. Only used when the backend is mysql.
#                          type:String
#
# $mysql_username::        MySQL server username. Only used when the backend is mysql.
#                          type:String
#
# $mysql_password::        MySQL server password. Only used when the backend is mysql.
#                          type:String
#
# $mysql_database::        MySQL server database. Only used when the backend is mysql.
#                          type:String
#
# $postgresql_connection:: The postgresql connection string.
#                          type:String
#
# $manage_database::       Whether to manage the database. Only works for
#                          mysql. Includes the mysql server.
#                          type:Boolean
#
# $pdnssec::               pdnssec command to run rectify-zone with. Can be an
#                          empty string.
#                          type:String
#
class foreman_proxy::plugin::dns::powerdns (
  $backend               = $::foreman_proxy::plugin::dns::powerdns::params::backend,
  $mysql_hostname        = $::foreman_proxy::plugin::dns::powerdns::params::mysql_hostname,
  $mysql_username        = $::foreman_proxy::plugin::dns::powerdns::params::mysql_username,
  $mysql_password        = $::foreman_proxy::plugin::dns::powerdns::params::mysql_password,
  $mysql_database        = $::foreman_proxy::plugin::dns::powerdns::params::mysql_database,
  $postgresql_connection = $::foreman_proxy::plugin::dns::powerdns::params::postgresql_connection,
  $manage_database       = $::foreman_proxy::plugin::dns::powerdns::params::manage_database,
  $pdnssec               = $::foreman_proxy::plugin::dns::powerdns::params::pdnssec,
) inherits foreman_proxy::plugin::dns::powerdns::params {
  validate_bool($manage_database)
  validate_re($backend, '^mysql|postgresql$', 'Invalid backend: choose mysql or postgresql')
  validate_string($mysql_hostname, $mysql_username, $mysql_password, $mysql_database, $postgresql_connection, $pdnssec)

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
  } ->
  foreman_proxy::settings_file { 'dns_powerdns':
    module        => false,
    template_path => 'foreman_proxy/plugin/dns_powerdns.yml.erb',
  }
}
