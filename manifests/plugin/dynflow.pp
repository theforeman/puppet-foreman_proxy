# = Foreman Proxy Dynflow plugin
#
# This class installs Dynflow support for Foreman proxy
#
# === Parameters:
#
# $database_path::   Path to the SQLite database file
#
# $console_auth::    Whether to enable trusted hosts and ssl for the dynflow console
#                    type:boolean
#
# === Advanced parameters:
#
# $enabled::         Enables/disables the plugin
#                    type:boolean
#
# $listen_on::       Proxy feature listens on https, http, or both
#
# $core_listen::     Address to listen on for the dynflow core service
#
# $core_port::       Port to use for the local dynflow core service
#                    type:integer
#
class foreman_proxy::plugin::dynflow (
  $enabled           = $::foreman_proxy::plugin::dynflow::params::enabled,
  $listen_on         = $::foreman_proxy::plugin::dynflow::params::listen_on,
  $database_path     = $::foreman_proxy::plugin::dynflow::params::database_path,
  $console_auth      = $::foreman_proxy::plugin::dynflow::params::console_auth,
  $core_listen       = $::foreman_proxy::plugin::dynflow::params::core_listen,
  $core_port         = $::foreman_proxy::plugin::dynflow::params::core_port,
) inherits foreman_proxy::plugin::dynflow::params {

  validate_integer($core_port)
  validate_bool($enabled, $console_auth)
  validate_listen_on($listen_on)
  validate_absolute_path($database_path)

  if $::foreman_proxy::ssl {
    $core_url = "https://${::fqdn}:${core_port}"
  } else {
    $core_url = "http://${::fqdn}:${core_port}"
  }

  foreman_proxy::plugin { 'dynflow':
  } ->
  foreman_proxy::settings_file { 'dynflow':
    enabled       => $enabled,
    listen_on     => $listen_on,
    template_path => 'foreman_proxy/plugin/dynflow.yml.erb',
  }

  if $::osfamily == 'RedHat' and $::operatingsystem != 'Fedora' {
    $scl_prefix = 'tfm-'
  } else {
    $scl_prefix = '' # lint:ignore:empty_string_assignment
  }

  # Currently the service is only needed on Red Hat OS's with SCL
  if $scl_prefix != '' {
    foreman_proxy::plugin { 'dynflow_core':
      package => "${scl_prefix}${::foreman_proxy::plugin_prefix}dynflow_core",
    } ~>
    file { '/etc/smart_proxy_dynflow_core/settings.yml':
      ensure  => file,
      content => template('foreman_proxy/plugin/dynflow_core.yml.erb'),
    } ~>
    service { 'smart_proxy_dynflow_core':
      ensure => running,
      enable => true,
    }
  }
}
