# = Foreman Proxy Pulp plugin
#
# This class installs pulp plugin
#
# === Advanced parameters:
#
# $enabled::            enables/disables the pulp plugin
#                       type:Boolean
#
# $group::              group owner of the configuration file
#                       type:Optional[String]
#
# $listen_on::          proxy feature listens on http, https, or both
#                       type:Foreman_proxy::ListenOn
#
# $version::            plugin package version, it's passed to ensure parameter of package resource
#                       can be set to specific version number, 'latest', 'present' etc.
#                       type:Optional[String]
#
# $pulp_url::           pulp url to use
#                       type:Stdlib::HTTPUrl
#
# $pulp_dir::           directory for pulp
#                       type:Stdlib::Absolutepath
#
# $pulp_content_dir::   directory for pulp content
#                       type:Stdlib::Absolutepath
#
# $pulpnode_enabled::   enables/disables the pulpnode plugin
#                       type:Boolean
#
# $puppet_content_dir:: directory for puppet content
#                       type:Stdlib::Absolutepath
#
# $mongodb_dir::        directory for Mongo DB
#                       type:Stdlib::Absolutepath
#
class foreman_proxy::plugin::pulp (
  Boolean $enabled                          = $::foreman_proxy::plugin::pulp::params::enabled,
  Foreman_proxy::ListenOn $listen_on        = $::foreman_proxy::plugin::pulp::params::listen_on,
  Boolean $pulpnode_enabled                 = $::foreman_proxy::plugin::pulp::params::pulpnode_enabled,
  Optional[String] $version                 = $::foreman_proxy::plugin::pulp::params::version,
  Optional[String] $group                   = $::foreman_proxy::plugin::pulp::params::group,
  Stdlib::HTTPUrl $pulp_url                 = $::foreman_proxy::plugin::pulp::params::pulp_url,
  Stdlib::Absolutepath $pulp_dir            = $::foreman_proxy::plugin::pulp::params::pulp_dir,
  Stdlib::Absolutepath $pulp_content_dir    = $::foreman_proxy::plugin::pulp::params::pulp_content_dir,
  Stdlib::Absolutepath $puppet_content_dir  = $::foreman_proxy::plugin::pulp::params::puppet_content_dir,
  Stdlib::Absolutepath $mongodb_dir         = $::foreman_proxy::plugin::pulp::params::mongodb_dir
) inherits foreman_proxy::plugin::pulp::params {

  foreman_proxy::plugin {'pulp':
    version => $version,
  } ->
  foreman_proxy::settings_file { 'pulp':
    template_path => 'foreman_proxy/plugin/pulp.yml.erb',
    group         => $group,
    enabled       => $enabled,
    listen_on     => $listen_on,
  } ->
  foreman_proxy::settings_file { 'pulpnode':
    template_path => 'foreman_proxy/plugin/pulpnode.yml.erb',
    group         => $group,
    enabled       => $pulpnode_enabled,
    listen_on     => $listen_on,
  }
}
