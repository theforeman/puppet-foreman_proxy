# @summary Configure the foreman proxy
# @api private
class foreman_proxy::config {
  # Ensure SSL certs from the puppetmaster are available
  # Relationship is duplicated there as defined() is parse-order dependent
  if $foreman_proxy::ssl and defined(Class['puppet::server::config']) {
    Class['puppet::server::config'] ~> Class['foreman_proxy::config']
    Class['puppet::server::config'] ~> Class['foreman_proxy::service']
  }

  # Ensure 'puppet' user group is present before managing proxy user
  # Relationship is duplicated there as defined() is parse-order dependent
  if defined(Class['puppet::server::install']) {
    Class['puppet::server::install'] -> Class['foreman_proxy::config']
  }

  if $foreman_proxy::tftp and $foreman_proxy::tftp_managed { include foreman_proxy::tftp }

  # Somehow, calling these DHCP and DNS seems to conflict. So, they get a prefix...
  if $foreman_proxy::dhcp and $foreman_proxy::dhcp_provider in ['isc', 'remote_isc'] and $foreman_proxy::dhcp_managed {
    include foreman_proxy::proxydhcp
  }

  if $foreman_proxy::dns and $foreman_proxy::dns_provider in ['nsupdate', 'nsupdate_gss'] and $foreman_proxy::dns_managed {
    include foreman_proxy::proxydns
    $dns_groups = [$foreman_proxy::proxydns::user_group]
  } elsif $foreman_proxy::dns and $foreman_proxy::dns_provider in ['infoblox', 'powerdns', 'route53'] {
    include "foreman_proxy::plugin::dns::${foreman_proxy::dns_provider}"
    $dns_groups = []
  } else {
    $dns_groups = []
  }

  # uses the certs to connect to puppetserver
  if $foreman_proxy::puppet or $foreman_proxy::puppetca or ($foreman_proxy::manage_puppet_group and $foreman_proxy::ssl) {
    $puppet_groups = [$foreman_proxy::puppet_group]
  } else {
    $puppet_groups = []
  }

  user { $foreman_proxy::user:
    ensure  => 'present',
    shell   => $foreman_proxy::shell,
    comment => 'Foreman Proxy daemon user',
    gid     => $foreman_proxy::group,
    groups  => $foreman_proxy::groups + $dns_groups + $puppet_groups,
    home    => $foreman_proxy::dir,
    system  => true,
  }

  group { $foreman_proxy::group:
    system => true,
  }

  # Provided by packaging, defined here to allow autorequire for files
  file { $foreman_proxy::config_dir:
    ensure => directory,
    owner  => 'root',
    group  => 0,
  }

  foreman_proxy::settings_file { 'settings':
    path => "${foreman_proxy::config_dir}/settings.yml",
  }

  contain foreman_proxy::module::bmc

  contain foreman_proxy::module::dhcp
  foreman_proxy::provider { ['dhcp_isc', 'dhcp_libvirt']:
  }

  contain foreman_proxy::module::dns
  foreman_proxy::provider { ['dns_nsupdate', 'dns_nsupdate_gss', 'dns_libvirt']:
  }

  contain foreman_proxy::module::httpboot

  contain foreman_proxy::module::puppet
  foreman_proxy::provider { 'puppet_proxy_puppet_api':
  }
  foreman_proxy::provider { [
      'puppet_proxy_legacy',
      'puppet_proxy_puppetrun',
      'puppet_proxy_customrun',
      'puppet_proxy_mcollective',
      'puppet_proxy_salt',
      'puppet_proxy_ssh',
    ]:
      ensure => 'absent',
  }

  contain foreman_proxy::module::puppetca
  foreman_proxy::provider { ['puppetca_hostname_whitelisting', 'puppetca_token_whitelisting']:
  }
  foreman_proxy::provider { 'puppetca_http_api':
  }
  # Foreman Proxy 3.4 dropped puppetca_puppet_cert
  foreman_proxy::provider { 'puppetca_puppet_cert':
    ensure => absent,
  }

  contain foreman_proxy::module::realm
  foreman_proxy::provider { 'realm_freeipa':
  }

  contain foreman_proxy::module::tftp

  contain foreman_proxy::module::templates

  contain foreman_proxy::module::logs

  contain foreman_proxy::module::registration

  unless $foreman_proxy::puppetca or $foreman_proxy::puppet {
    # The puppet-agent doesn't create a puppet user and group
    # but the foreman proxy still needs to be able to read the agent's private key
    if $foreman_proxy::manage_puppet_group and $foreman_proxy::ssl {
      if !defined(Group[$foreman_proxy::puppet_group]) {
        group { $foreman_proxy::puppet_group:
          ensure => 'present',
          before => User[$foreman_proxy::user],
        }
      }
      $ssl_dirs_and_files = [
        $foreman_proxy::ssldir,
        "${foreman_proxy::ssldir}/private_keys",
        $foreman_proxy::ssl_ca,
        $foreman_proxy::ssl_key,
        $foreman_proxy::ssl_cert,
      ]
      file { $ssl_dirs_and_files:
        group => $foreman_proxy::puppet_group,
      }
    }
  }

  if $foreman_proxy::manage_certificates {
    file { "${foreman_proxy::config_dir}/ssl_ca.pem":
      ensure => file,
      source => $foreman_proxy::ssl_ca,
      owner  => 'root',
      group  => $foreman_proxy::group,
      mode   => '0440',
    }

    file { "${foreman_proxy::config_dir}/ssl_cert.pem":
      ensure => file,
      source => $foreman_proxy::ssl_cert,
      owner  => 'root',
      group  => $foreman_proxy::group,
      mode   => '0440',
    }

    file { "${foreman_proxy::config_dir}/ssl_key.pem":
      ensure => file,
      source => $foreman_proxy::ssl_key,
      owner  => 'root',
      group  => $foreman_proxy::group,
      mode   => '0440',
    }

    if $foreman_proxy::foreman_ssl_ca {
      file { "${foreman_proxy::config_dir}/foreman_ssl_ca.pem":
        ensure => file,
        source => $foreman_proxy::foreman_ssl_ca,
        owner  => 'root',
        group  => $foreman_proxy::group,
        mode   => '0440',
      }
    }

    if $foreman_proxy::foreman_ssl_cert {
      file { "${foreman_proxy::config_dir}/foreman_ssl_cert.pem":
        ensure => file,
        source => $foreman_proxy::foreman_ssl_cert,
        owner  => 'root',
        group  => $foreman_proxy::group,
        mode   => '0440',
      }
    }

    if $foreman_proxy::foreman_ssl_key {
      file { "${foreman_proxy::config_dir}/foreman_ssl_key.pem":
        ensure => file,
        source => $foreman_proxy::foreman_ssl_key,
        owner  => 'root',
        group  => $foreman_proxy::group,
        mode   => '0440',
      }
    }
  }
}
