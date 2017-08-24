# = Foreman Proxy Dynflow plugin
#
# This class installs Dynflow support for Foreman proxy
#
# === Parameters:
#
# $database_path::   Path to the SQLite database file, set empty for in-memory sqlite
#
# $console_auth::    Whether to enable trusted hosts and ssl for the dynflow console
#
# === Advanced parameters:
#
# $enabled::         Enables/disables the dynflow plugin
#
# $listen_on::       Proxy feature listens on https, http, or both
#
# $core_listen::     Address to listen on for the dynflow core service
#
# $core_port::       Port to use for the local dynflow core service
#
# $ssl_disabled_ciphers:: Disable SSL ciphers
#
class foreman_proxy::plugin::dynflow (
  Boolean $enabled = $::foreman_proxy::plugin::dynflow::params::enabled,
  Foreman_proxy::ListenOn $listen_on = $::foreman_proxy::plugin::dynflow::params::listen_on,
  Optional[Stdlib::Absolutepath] $database_path = $::foreman_proxy::plugin::dynflow::params::database_path,
  Boolean $console_auth = $::foreman_proxy::plugin::dynflow::params::console_auth,
  String $core_listen = $::foreman_proxy::plugin::dynflow::params::core_listen,
  Integer[0, 65535] $core_port = $::foreman_proxy::plugin::dynflow::params::core_port,
  Optional[Array[String]] $ssl_disabled_ciphers = $::foreman_proxy::plugin::dynflow::params::ssl_disabled_ciphers,
) inherits foreman_proxy::plugin::dynflow::params {
  if $::foreman_proxy::ssl {
    $core_url = "https://${::fqdn}:${core_port}"
  } else {
    $core_url = "http://${::fqdn}:${core_port}"
  }

  foreman_proxy::plugin { 'dynflow':
  }
  -> foreman_proxy::settings_file { 'dynflow':
    enabled       => $enabled,
    feature       => 'Dynflow',
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
    }
    ~> file { '/etc/smart_proxy_dynflow_core/settings.yml':
      ensure  => file,
      content => template('foreman_proxy/plugin/dynflow_core.yml.erb'),
    }
    ~> file { '/etc/smart_proxy_dynflow_core/settings.d':
      ensure => link,
      target => '/etc/foreman-proxy/settings.d',
    }
    ~> service { 'smart_proxy_dynflow_core':
      ensure => running,
      enable => true,
    }
  }
}
