# = Foreman Proxy Dynflow plugin
#
# This class installs Dynflow support for Foreman proxy
#
# === Parameters:
#
# $database_path::         Path to the SQLite database file, set empty for in-memory sqlite
#
# $console_auth::          Whether to enable trusted hosts and ssl for the dynflow console
#
# === Advanced parameters:
#
# $enabled::               Enables/disables the dynflow plugin
#
# $listen_on::             Proxy feature listens on https, http, or both
#
# $core_listen::           Address to listen on for the dynflow core service
#
# $core_port::             Port to use for the local dynflow core service
#
# $ssl_disabled_ciphers::  Disable SSL ciphers. For example: ['NULL-MD5', 'NULL-SHA']
#
# $tls_disabled_versions:: Disable TLS versions. Version 1.0 is always disabled. For example: ['1.1']
#
# $open_file_limit::       Limit number of open files - Only Red Hat Operating Systems with Software Collections.
#
# $external_core::         Forces usage of external/internal Dynflow core
class foreman_proxy::plugin::dynflow (
  Boolean $enabled = $foreman_proxy::plugin::dynflow::params::enabled,
  Foreman_proxy::ListenOn $listen_on = $foreman_proxy::plugin::dynflow::params::listen_on,
  Optional[Stdlib::Absolutepath] $database_path = $foreman_proxy::plugin::dynflow::params::database_path,
  Boolean $console_auth = $foreman_proxy::plugin::dynflow::params::console_auth,
  String $core_listen = $foreman_proxy::plugin::dynflow::params::core_listen,
  Integer[0, 65535] $core_port = $foreman_proxy::plugin::dynflow::params::core_port,
  Optional[Array[String]] $ssl_disabled_ciphers = $foreman_proxy::plugin::dynflow::params::ssl_disabled_ciphers,
  Optional[Array[String]] $tls_disabled_versions = $foreman_proxy::plugin::dynflow::params::tls_disabled_versions,
  Integer[1] $open_file_limit = $foreman_proxy::plugin::dynflow::params::open_file_limit,
  Boolean $external_core = $foreman_proxy::plugin::dynflow::params::external_core,
) inherits foreman_proxy::plugin::dynflow::params {
  if $foreman_proxy::ssl {
    $core_url = "https://${facts['networking']['fqdn']}:${core_port}"
  } else {
    $core_url = "http://${facts['networking']['fqdn']}:${core_port}"
  }

  foreman_proxy::plugin::module { 'dynflow':
    enabled   => $enabled,
    listen_on => $listen_on,
  }

  if $external_core {
    $service = 'smart_proxy_dynflow_core'

    file { '/etc/smart_proxy_dynflow_core/settings.yml':
      ensure  => file,
      content => template('foreman_proxy/plugin/dynflow_core.yml.erb'),
      require => Foreman_proxy::Plugin['dynflow_core'],
      notify  => Service[$service],
    }

    file { '/etc/smart_proxy_dynflow_core/settings.d':
      ensure  => link,
      target  => "${foreman_proxy::config_dir}/settings.d",
      require => Foreman_proxy::Plugin['dynflow_core'],
      notify  => Service[$service],
    }
  } else {
    $service = 'foreman-proxy'
  }

  foreman_proxy::plugin { 'dynflow_core':
    notify  => Service[$service],
  }

  systemd::service_limits { "${service}.service":
    limits          => {
      'LimitNOFILE' => $open_file_limit,
    },
    restart_service => false,
    require         => Foreman_proxy::Plugin['dynflow_core'],
    notify          => Service[$service],
  }

  service { 'smart_proxy_dynflow_core':
    ensure => $external_core,
    enable => $external_core,
  }
}
