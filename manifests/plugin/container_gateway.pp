# = Foreman Proxy Container Gateway plugin
#
# This class installs the Container Gateway plugin
#
# $pulp_endpoint::            Pulp 3 server endpoint
#
# $database_backend::         'sqlite' or 'postgres'
#
# $postgresql_host::          Host of the postgres database.
#
# $postgresql_port::          Port of the postgres database.
#
# $postgresql_database::      Name of the postgres database
#
# $postgresql_user::          User for the postgres database
#
# $postgresql_password::      User password for the postgres database
#
# $sqlite_db_path::           Absolute path for the SQLite DB file to exist at
#
# $sqlite_timeout::           Database busy timeout in milliseconds
#
# === Advanced parameters:
#
# $enabled::                  enables/disables the pulp plugin
#
# $listen_on::                proxy feature listens on http, https, or both
#
# $version::                  plugin package version, it's passed to ensure parameter of package resource
#                             can be set to specific version number, 'latest', 'present' etc.
#
class foreman_proxy::plugin::container_gateway (
  Optional[String] $version = undef,
  Boolean $enabled = true,
  Foreman_proxy::ListenOn $listen_on = 'https',
  Stdlib::HTTPUrl $pulp_endpoint = "https://${facts['networking']['fqdn']}",
  String $database_backend = 'postgres',
  Stdlib::Absolutepath $sqlite_db_path = '/var/lib/foreman-proxy/smart_proxy_container_gateway.db',
  Optional[Integer] $sqlite_timeout = undef,
  Stdlib::Host $postgresql_host = 'localhost',
  Stdlib::Port $postgresql_port = 5432,
  String $postgresql_database = 'container_gateway',
  String $postgresql_user = 'foreman-proxy',
  String $postgresql_password = extlib::cache_data('container_gateway_cache_data', 'db_password', extlib::random_password(32))
) {
  foreman_proxy::plugin::module { 'container_gateway':
    version   => $version,
    enabled   => $enabled,
    feature   => 'Container_Gateway',
    listen_on => $listen_on,
  }
  include postgresql::server
  postgresql::server::db { $foreman_proxy::plugin::container_gateway::postgresql_database:
    user     => $foreman_proxy::plugin::container_gateway::postgresql_user,
    password => postgresql::postgresql_password(
      $foreman_proxy::plugin::container_gateway::postgresql_user,
      $foreman_proxy::plugin::container_gateway::postgresql_password
    ),
    encoding => 'utf8',
    locale   => 'en_US.utf8',
    require  => Package['glibc-langpack-en'],
  }
}
