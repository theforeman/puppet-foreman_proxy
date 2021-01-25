# = Foreman Proxy Container Gateway plugin
#
# This class installs the Container Gateway plugin
#
# $pulp_endpoint::            Pulp 3 server endpoint
#
# $sqlite_db_path::           Absolute path for the SQLite DB file to exist at
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
  Stdlib::Absolutepath $sqlite_db_path = '/var/lib/foreman-proxy/smart_proxy_container_gateway.db',
) {
  foreman_proxy::plugin::module { 'container_gateway':
    version   => $version,
    enabled   => $enabled,
    feature   => 'Container_Gateway',
    listen_on => $listen_on,
  }
}
