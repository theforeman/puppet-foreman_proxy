# = Foreman Proxy Pulp plugin
#
# This class installs pulp plugin
#
# === Advanced parameters:
#
# $enabled::            enables/disables the pulp plugin
#
# $listen_on::          proxy feature listens on http, https, or both
#
# $version::            plugin package version, it's passed to ensure parameter of package resource
#                       can be set to specific version number, 'latest', 'present' etc.
#
# $pulp_url::           pulp url to use
#
# $pulp_dir::           directory for pulp
#
# $pulp_content_dir::   directory for pulp content
#
# $pulpnode_enabled::   enables/disables the pulpnode plugin
#
# $pulpcore_enabled::      enables/disables the pulpcore plugin
#
# $pulpcore_mirror::       Whether this pulpcore plugin acts as a mirror or another pulp node. A pulpcore mirror is the pulpcore equivalent of a pulpnode.
#
# $pulpcore_api_url::      The URL to the Pulp 3 API
#
# $pulpcore_content_url::  The URL to the Pulp 3 content
#
# $puppet_content_dir:: Directory for puppet content. Automatically determined if empty.
#
# $mongodb_dir::        directory for Mongo DB
#
class foreman_proxy::plugin::pulp (
  Boolean $enabled = $::foreman_proxy::plugin::pulp::params::enabled,
  Foreman_proxy::ListenOn $listen_on = $::foreman_proxy::plugin::pulp::params::listen_on,
  Boolean $pulpnode_enabled = $::foreman_proxy::plugin::pulp::params::pulpnode_enabled,
  Boolean $pulpcore_enabled = $::foreman_proxy::plugin::pulp::params::pulpcore_enabled,
  Stdlib::HTTPUrl $pulpcore_api_url = $::foreman_proxy::plugin::pulp::params::pulpcore_api_url,
  Stdlib::HTTPUrl $pulpcore_content_url = $::foreman_proxy::plugin::pulp::params::pulpcore_content_url,
  Boolean $pulpcore_mirror = $::foreman_proxy::plugin::pulp::params::pulpcore_mirror,
  Optional[String] $version = $::foreman_proxy::plugin::pulp::params::version,
  Stdlib::HTTPUrl $pulp_url = $::foreman_proxy::plugin::pulp::params::pulp_url,
  Stdlib::Absolutepath $pulp_dir = $::foreman_proxy::plugin::pulp::params::pulp_dir,
  Stdlib::Absolutepath $pulp_content_dir = $::foreman_proxy::plugin::pulp::params::pulp_content_dir,
  Optional[Stdlib::Absolutepath] $puppet_content_dir = $::foreman_proxy::plugin::pulp::params::puppet_content_dir,
  Stdlib::Absolutepath $mongodb_dir = $::foreman_proxy::plugin::pulp::params::mongodb_dir,
) inherits foreman_proxy::plugin::pulp::params {
  $real_puppet_content_dir = pick($puppet_content_dir, lookup('puppet::server_envs_dir') |$key| { undef }, $facts['puppet_environmentpath'], "${foreman_proxy::puppetdir}/environments")

  foreman_proxy::plugin {'pulp':
    version => $version,
  }
  -> [
    foreman_proxy::settings_file { 'pulp':
      template_path => 'foreman_proxy/plugin/pulp.yml.erb',
      enabled       => $enabled,
      feature       => 'Pulp',
      listen_on     => $listen_on,
    },
    foreman_proxy::settings_file { 'pulpnode':
      template_path => 'foreman_proxy/plugin/pulpnode.yml.erb',
      enabled       => $pulpnode_enabled,
      feature       => 'Pulp Node',
      listen_on     => $listen_on,
    },
    foreman_proxy::settings_file { 'pulpcore':
      template_path => 'foreman_proxy/plugin/pulpcore.yml.erb',
      enabled       => $pulpcore_enabled,
      feature       => 'Pulpcore',
      listen_on     => $listen_on,
    },
    foreman_proxy::settings_file { 'pulp3': # file removed in rubygem-smart_proxy_pulp 2.0
      ensure        => absent,
    },
  ]
}
