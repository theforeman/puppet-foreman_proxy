# = Foreman Proxy Container Gateway plugin
#
# This class installs the Container Gateway plugin
#
# $pulp_endpoint::            Pulp 3 server endpoint
#
# $database_backend::         'sqlite' or 'postgres'
#
# $manage_postgresql::        If the PostgreSQL database should be managed
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
  Enum['postgres', 'sqlite'] $database_backend = 'postgres',
  Stdlib::Absolutepath $sqlite_db_path = '/var/lib/foreman-proxy/smart_proxy_container_gateway.db',
  Optional[Integer] $sqlite_timeout = undef,
  Boolean $manage_postgresql = true,
  Optional[Stdlib::Host] $postgresql_host = undef,
  Optional[Stdlib::Port] $postgresql_port = undef,
  String $postgresql_database = 'container_gateway',
  Optional[String[1]] $postgresql_user = undef,
  Optional[String] $postgresql_password = undef
) {
  foreman_proxy::plugin::module { 'container_gateway':
    version   => $version,
    enabled   => $enabled,
    feature   => 'Container_Gateway',
    listen_on => $listen_on,
  }

  if $version != 'absent' and $enabled and $manage_postgresql and $database_backend == 'postgres' {
    include postgresql::server
    $_postgresql_user = pick($postgresql_user, $foreman_proxy::user)
    if $postgresql_password {
      postgresql::server::db { $postgresql_database:
        user     => $_postgresql_user,
        password => postgresql::postgresql_password(
          $_postgresql_user,
          $postgresql_password
        ),
        encoding => 'utf8',
        locale   => 'C.utf8',
      }
    } else {
      postgresql::server::db { $postgresql_database:
        user     => $_postgresql_user,
        encoding => 'utf8',
        locale   => 'C.utf8',
      }
    }
  }
}
