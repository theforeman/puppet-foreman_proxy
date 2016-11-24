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
  $enabled            = $::foreman_proxy::plugin::pulp::params::enabled,
  $listen_on          = $::foreman_proxy::plugin::pulp::params::listen_on,
  $pulpnode_enabled   = $::foreman_proxy::plugin::pulp::params::pulpnode_enabled,
  $version            = $::foreman_proxy::plugin::pulp::params::version,
  $group              = $::foreman_proxy::plugin::pulp::params::group,
  $pulp_url           = $::foreman_proxy::plugin::pulp::params::pulp_url,
  $pulp_dir           = $::foreman_proxy::plugin::pulp::params::pulp_dir,
  $pulp_content_dir   = $::foreman_proxy::plugin::pulp::params::pulp_content_dir,
  $puppet_content_dir = $::foreman_proxy::plugin::pulp::params::puppet_content_dir,
  $mongodb_dir        = $::foreman_proxy::plugin::pulp::params::mongodb_dir
) inherits foreman_proxy::plugin::pulp::params {

  validate_bool($enabled)
  validate_bool($pulpnode_enabled)
  validate_absolute_path($pulp_dir)
  validate_absolute_path($pulp_content_dir)
  validate_absolute_path($puppet_content_dir)
  validate_absolute_path($mongodb_dir)

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
