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
# $ssl_disabled_ciphers::  Disable SSL ciphers. For example: ['NULL-MD5', 'NULL-SHA']
#
# $tls_disabled_versions:: Disable TLS versions. Version 1.0 is always disabled. For example: ['1.1']
#
# $open_file_limit::       Limit number of open files - Only Red Hat Operating Systems with Software Collections.
class foreman_proxy::plugin::dynflow (
  Boolean $enabled = $foreman_proxy::plugin::dynflow::params::enabled,
  Foreman_proxy::ListenOn $listen_on = $foreman_proxy::plugin::dynflow::params::listen_on,
  Optional[Stdlib::Absolutepath] $database_path = $foreman_proxy::plugin::dynflow::params::database_path,
  Boolean $console_auth = $foreman_proxy::plugin::dynflow::params::console_auth,
  Optional[Array[String]] $ssl_disabled_ciphers = $foreman_proxy::plugin::dynflow::params::ssl_disabled_ciphers,
  Optional[Array[String]] $tls_disabled_versions = $foreman_proxy::plugin::dynflow::params::tls_disabled_versions,
  Integer[1] $open_file_limit = $foreman_proxy::plugin::dynflow::params::open_file_limit,
) inherits foreman_proxy::plugin::dynflow::params {
  foreman_proxy::plugin::module { 'dynflow':
    enabled   => $enabled,
    listen_on => $listen_on,
  }

  file { '/etc/smart_proxy_dynflow_core/settings.yml':
    ensure => absent,
  }
  -> file { '/etc/smart_proxy_dynflow_core/settings.d':
    ensure => absent,
  }
  -> foreman_proxy::plugin { 'dynflow_core':
    version => absent,
  }

  $service = 'foreman-proxy.service'

  systemd::manage_dropin { "${service}-90-limits.conf":
    unit           => $service,
    filename       => '90-limits.conf',
    service_entry  => {
      'LimitNOFILE' => $open_file_limit,
    },
    notify_service => true,
  }
}
