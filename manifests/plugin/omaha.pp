# = Foreman Proxy Omaha plugin
#
# This class installs the omaha plugin
#
# === Parameters:
#
# $contentpath::        Path where omaha content is stored
#                       type:Stdlib::Absolutepath
#
# $sync_releases::      How many of the latest releases should be synced
#                       type:Integer[0]
#
# $http_proxy::         URL to a proxy server that should be used to retrieve omaha content, e.g. 'http://proxy.example.com:3128/'
#                       type:Optional[Stdlib::HTTPUrl]
#
# === Advanced parameters:
#
# $enabled::            enables/disables the omaha plugin
#                       type:Boolean
#
# $group::              owner of plugin configuration
#                       type:Optional[String]
#
# $listen_on::          proxy feature listens on http, https, or both
#                       type:Foreman_proxy::ListenOn
#
# $version::            plugin package version, it's passed to ensure parameter of package resource
#                       can be set to specific version number, 'latest', 'present' etc.
#                       type:Optional[String]
#
class foreman_proxy::plugin::omaha (
  $enabled            = $::foreman_proxy::plugin::omaha::params::enabled,
  $group              = $::foreman_proxy::plugin::omaha::params::group,
  $listen_on          = $::foreman_proxy::plugin::omaha::params::listen_on,
  $contentpath        = $::foreman_proxy::plugin::omaha::params::contentpath,
  $sync_releases      = $::foreman_proxy::plugin::omaha::params::sync_releases,
  $http_proxy         = $::foreman_proxy::plugin::omaha::params::http_proxy,
  $version            = $::foreman_proxy::plugin::omaha::params::version,
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
  } ->
  foreman_proxy::settings_file { 'omaha':
    template_path => 'foreman_proxy/plugin/omaha.yml.erb',
    group         => $group,
    enabled       => $enabled,
    listen_on     => $listen_on,
  }

  exec { "mkdir_p-${contentpath}":
    command => "mkdir -p ${contentpath}",
    creates => $contentpath,
    path    => '/bin:/usr/bin',
  } ->
  file { $contentpath:
    ensure  => directory,
  }
}
