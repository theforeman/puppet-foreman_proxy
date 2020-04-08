# = Foreman Proxy Omaha plugin
#
# This class installs the omaha plugin
#
# === Parameters:
#
# $contentpath::        Path where omaha content is stored
#
# $sync_releases::      How many of the latest releases should be synced
#
# $http_proxy::         URL to a proxy server that should be used to retrieve omaha content, e.g. 'http://proxy.example.com:3128/'
#
# === Advanced parameters:
#
# $enabled::            enables/disables the omaha plugin
#
# $listen_on::          proxy feature listens on http, https, or both
#
# $version::            plugin package version, it's passed to ensure parameter of package resource
#                       can be set to specific version number, 'latest', 'present' etc.
#
# $distribution::       distribution type, it's passed to specify the distribution type.
#                       can be set to one of 'coreos' (default), 'flatcar'
#
class foreman_proxy::plugin::omaha (
  Boolean $enabled = true,
  Foreman_proxy::ListenOn $listen_on = 'https',
  Stdlib::Absolutepath $contentpath = '/var/lib/foreman-proxy/omaha/content',
  Integer[0] $sync_releases = 2,
  Optional[Stdlib::HTTPUrl] $http_proxy = undef,
  Optional[String] $version = undef,
  Optional[Enum['coreos','flatcar']] $distribution = undef,
) {
  foreman_proxy::plugin::module { 'omaha':
    version   => $version,
    listen_on => $listen_on,
    enabled   => $enabled,
  }

  exec { "mkdir_p-${contentpath}":
    command => "mkdir -p ${contentpath}",
    creates => $contentpath,
    path    => '/bin:/usr/bin',
  }
  -> file { $contentpath:
    ensure  => directory,
  }
}
