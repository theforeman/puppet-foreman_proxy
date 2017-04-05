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
# $group::              owner of plugin configuration
#
# $listen_on::          proxy feature listens on http, https, or both
#
# $version::            plugin package version, it's passed to ensure parameter of package resource
#                       can be set to specific version number, 'latest', 'present' etc.
#
class foreman_proxy::plugin::omaha (
  Boolean $enabled = $::foreman_proxy::plugin::omaha::params::enabled,
  Optional[String] $group = $::foreman_proxy::plugin::omaha::params::group,
  Foreman_proxy::ListenOn $listen_on = $::foreman_proxy::plugin::omaha::params::listen_on,
  Stdlib::Absolutepath $contentpath = $::foreman_proxy::plugin::omaha::params::contentpath,
  Integer[0] $sync_releases = $::foreman_proxy::plugin::omaha::params::sync_releases,
  Optional[Stdlib::HTTPUrl] $http_proxy = $::foreman_proxy::plugin::omaha::params::http_proxy,
  Optional[String] $version = $::foreman_proxy::plugin::omaha::params::version,
) inherits foreman_proxy::plugin::omaha::params {
  validate_bool($enabled)
  validate_listen_on($listen_on)
  validate_absolute_path($contentpath)
  validate_integer($sync_releases)

  if $http_proxy {
    validate_string($http_proxy)
  }

  foreman_proxy::plugin { 'omaha':
    version => $version,
  }
  -> foreman_proxy::settings_file { 'omaha':
    template_path => 'foreman_proxy/plugin/omaha.yml.erb',
    group         => $group,
    enabled       => $enabled,
    listen_on     => $listen_on,
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
