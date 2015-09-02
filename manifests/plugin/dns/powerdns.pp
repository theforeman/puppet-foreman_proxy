# = Foreman Proxy PowerDNS DNS plugin
#
# This class installs the PowerDNS DNS plugin for Foreman proxy
#
# === Parameters:
#
# $mysql_hostname::  MySQL server hostname
#
# $mysql_username::  MySQL server username
#
# $mysql_password::  MySQL server password
#
# $mysql_database::  MySQL server database
#
# $manage_database:: Whether to manage the mysql database. Also includes the mysql server.
#
# $pdnssec::         pdnssec command to run rectify-zone with. Can be an empty string.
#
class foreman_proxy::plugin::dns::powerdns (
  $mysql_hostname  = $::foreman_proxy::plugin::dns::powerdns::params::mysql_hostname,
  $mysql_username  = $::foreman_proxy::plugin::dns::powerdns::params::mysql_username,
  $mysql_password  = $::foreman_proxy::plugin::dns::powerdns::params::mysql_password,
  $mysql_database  = $::foreman_proxy::plugin::dns::powerdns::params::mysql_database,
  $manage_database = $::foreman_proxy::plugin::dns::powerdns::params::manage_database,
  $pdnssec         = $::foreman_proxy::plugin::dns::powerdns::params::pdnssec,
) inherits foreman_proxy::plugin::dns::powerdns::params {
  validate_bool($manage_database)
  validate_string($mysql_hostname, $mysql_username, $mysql_password, $mysql_database, $pdnssec)

  if $manage_database {
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
