# = Foreman Proxy ACD plugin
#
# This class installs the ACD plugin
#
# === Parameters:
#
# === Advanced parameters:
#
# $enabled::                  enables/disables the acd plugin
#
# $listen_on::                proxy feature listens on http, https, or both
#
# $version::                  plugin package version, it's passed to ensure parameter of package resource
#                             can be set to specific version number, 'latest', 'present' etc.
#
class foreman_proxy::plugin::acd (
  Optional[String] $version = undef,
  Boolean $enabled = true,
  Foreman_proxy::ListenOn $listen_on = 'https',
) {
  foreman_proxy::plugin::module { 'acd':
    enabled   => $enabled,
    feature   => 'ACD',
    listen_on => $listen_on,
    version   => $version,
  }
}
