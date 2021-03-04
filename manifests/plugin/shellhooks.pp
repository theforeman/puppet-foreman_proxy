# = Foreman Proxy Shelhooks plugin
#
# This class installs the Shellhooks plugin
#
# === Parameters:
#
# $directory::                Absolute path to directory with executables
#
# === Advanced parameters:
#
# $enabled::                  enables/disables the shellhooks plugin
#
# $listen_on::                proxy feature listens on http, https, or both
#
# $version::                  plugin package version, it's passed to ensure parameter of package resource
#                             can be set to specific version number, 'latest', 'present' etc.
#
class foreman_proxy::plugin::shellhooks (
  Optional[String] $version = undef,
  Boolean $enabled = true,
  Stdlib::Absolutepath $directory = '/var/lib/foreman-proxy/shellhooks',
  Foreman_proxy::ListenOn $listen_on = 'https',
) {
  foreman_proxy::plugin::module { 'shellhooks':
    enabled   => $enabled,
    feature   => 'Shellhooks',
    listen_on => $listen_on,
    version   => $version,
  }
}
