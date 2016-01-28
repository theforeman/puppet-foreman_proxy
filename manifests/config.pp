# Configure the foreman proxy
class foreman_proxy::config {

  # Ensure SSL certs from the puppetmaster are available
  # Relationship is duplicated there as defined() is parse-order dependent
  if $foreman_proxy::ssl and defined(Class['puppet::server::config']) {
    Class['puppet::server::config'] ~> Class['foreman_proxy::config']
    Class['puppet::server::config'] ~> Class['foreman_proxy::service']
  }

  if $foreman_proxy::puppetca { include ::foreman_proxy::puppetca }
  if $foreman_proxy::tftp     { include ::foreman_proxy::tftp }

  # Somehow, calling these DHCP and DNS seems to conflict. So, they get a prefix...
  if $foreman_proxy::dhcp and $foreman_proxy::dhcp_managed { include ::foreman_proxy::proxydhcp }

  if $foreman_proxy::dns and $foreman_proxy::dns_managed {
    include ::foreman_proxy::proxydns
    include ::dns::params
    $groups = [$dns::params::group, $foreman_proxy::puppet_group]
  } else {
    $groups = [$foreman_proxy::puppet_group]
  }

  user { $foreman_proxy::user:
    ensure  => 'present',
    shell   => $::foreman_proxy::shell,
    comment => 'Foreman Proxy account',
    groups  => $groups,
    home    => $foreman_proxy::dir,
    require => Class['foreman_proxy::install'],
    notify  => Class['foreman_proxy::service'],
  }

  foreman_proxy::settings_file { 'settings':
    path   => "${::foreman_proxy::etc}/foreman-proxy/settings.yml",
    module => false,
  }

  foreman_proxy::settings_file { 'bmc':
    enabled   => $::foreman_proxy::bmc,
    listen_on => $::foreman_proxy::bmc_listen_on,
  }
  foreman_proxy::settings_file { 'dhcp':
    enabled   => $::foreman_proxy::dhcp,
    listen_on => $::foreman_proxy::dhcp_listen_on,
  }
  if $::foreman_proxy::dhcp_split_config_files {
    foreman_proxy::settings_file { 'dhcp_isc':
      module => false,
    }
  }
  foreman_proxy::settings_file { 'dns':
    enabled   => $::foreman_proxy::dns,
    listen_on => $::foreman_proxy::dns_listen_on,
  }
  if $::foreman_proxy::dns_split_config_files {
    foreman_proxy::settings_file { ['dns_nsupdate', 'dns_nsupdate_gss']:
      module => false,
    }
  }
  foreman_proxy::settings_file { 'puppet':
    enabled   => $::foreman_proxy::puppetrun,
    listen_on => $::foreman_proxy::puppetrun_listen_on,
  }
  foreman_proxy::settings_file { 'puppetca':
    enabled   => $::foreman_proxy::puppetca,
    listen_on => $::foreman_proxy::puppetca_listen_on,
  }
  foreman_proxy::settings_file { 'realm':
    enabled   => $::foreman_proxy::realm,
    listen_on => $::foreman_proxy::realm_listen_on,
  }
  foreman_proxy::settings_file { 'tftp':
    enabled   => $::foreman_proxy::tftp,
    listen_on => $::foreman_proxy::tftp_listen_on,
  }
  foreman_proxy::settings_file { 'templates':
    enabled   => $::foreman_proxy::templates,
    listen_on => $::foreman_proxy::templates_listen_on,
  }
  foreman_proxy::settings_file { 'logs':
    enabled   => $::foreman_proxy::logs,
    listen_on => $::foreman_proxy::logs_listen_on,
  }

  if $foreman_proxy::puppetca or $foreman_proxy::puppetrun {
    if $foreman_proxy::use_sudoersd {
      if $foreman_proxy::manage_sudoersd {
        file { "${::foreman_proxy::sudoers}.d":
          ensure => directory,
        }
      }

      file { "${::foreman_proxy::sudoers}.d/foreman-proxy":
        ensure  => file,
        owner   => 'root',
        group   => 0,
        mode    => '0440',
        content => template('foreman_proxy/sudo.erb'),
      }
    } else {
      augeas { 'sudo-foreman-proxy':
        context => "/files${::foreman_proxy::sudoers}",
        changes => template('foreman_proxy/sudo_augeas.erb'),
      }
    }
  }

  if $foreman_proxy::puppet_use_cache {
    file { $foreman_proxy::puppet_cache_location:
      ensure => directory,
      owner  => $foreman_proxy::user,
      group  => 0,
      mode   => '0750',
    }
  }
}
