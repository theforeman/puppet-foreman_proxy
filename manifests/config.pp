class foreman_proxy::config {

  # Ensure SSL certs from the puppetmaster are available
  # Relationship is duplicated there as defined() is parse-order dependent
  $ssl = $::foreman_proxy::ssl
  if $ssl and defined(Class['puppet::server::config']) {
    Class['puppet::server::config'] -> Class['foreman_proxy::config']
    $default_ssl_ca = $::puppet::server::ssl_ca
    $default_ssl_cert = $::puppet::server::ssl_cert
    $default_ssl_key = $::puppet::server::ssl_key
  }
  else {
    $default_ssl_ca = $::foreman_proxy::params::default_ssl_ca
    $default_ssl_cert = $::foreman_proxy::params::default_ssl_cert
    $default_ssl_key = $::foreman_proxy::params::default_ssl_key
  }

  $ssl_ca = $::foreman_proxy::ssl_ca ? {
    undef   => $default_ssl_ca,
    default => $::foreman_proxy::ssl_ca,
  }
  $ssl_cert = $::foreman_proxy::ssl_cert ? {
    undef   => $default_ssl_cert,
    default => $::foreman_proxy::ssl_cert,
  }
  $ssl_key  = $::foreman_proxy::ssl_key ? {
    undef   => $default_ssl_key,
    default => $::foreman_proxy::ssl_key,
  }

  if $foreman_proxy::puppetca  { include foreman_proxy::puppetca }
  if $foreman_proxy::tftp      { include foreman_proxy::tftp }

  # Somehow, calling these DHCP and DNS seems to conflict. So, they get a prefix...
  if $foreman_proxy::dhcp and $foreman_proxy::dhcp_managed { include foreman_proxy::proxydhcp }

  if $foreman_proxy::dns {
    include foreman_proxy::proxydns
    include dns::params
    $groups = [$dns::params::group,$foreman_proxy::puppet_group]
  } else {
    $groups = [$foreman_proxy::puppet_group]
  }

  user { $foreman_proxy::user:
    ensure  => 'present',
    shell   => '/sbin/nologin',
    comment => 'Foreman Proxy account',
    groups  => $groups,
    home    => $foreman_proxy::dir,
    require => Class['foreman_proxy::install'],
    notify  => Class['foreman_proxy::service'],
  }

  file{'/etc/foreman-proxy/settings.yml':
    content => template('foreman_proxy/settings.yml.erb'),
    owner   => $foreman_proxy::user,
    group   => $foreman_proxy::user,
    mode    => '0644',
    require => Class['foreman_proxy::install'],
    notify  => Class['foreman_proxy::service'],
  }

  if $foreman_proxy::use_sudoersd {
    if $foreman_proxy::manage_sudoersd {
      file { '/etc/sudoers.d':
        ensure => directory,
      }
    }

    file { '/etc/sudoers.d/foreman-proxy':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => 0440,
      content => "foreman-proxy ALL = NOPASSWD : ${foreman_proxy::puppetca_cmd} *, ${foreman_proxy::puppetrun_cmd} *
Defaults:foreman-proxy !requiretty\n",
      require => File['/etc/sudoers.d'],
    }
  } else {
    augeas { 'sudo-foreman-proxy':
      context => '/files/etc/sudoers',
      changes => [
        "set spec[user = '${foreman_proxy::user}']/user ${foreman_proxy::user}",
        "set spec[user = '${foreman_proxy::user}']/host_group/host ALL",
        "set spec[user = '${foreman_proxy::user}']/host_group/command[1] '${foreman_proxy::puppetca_cmd} *'",
        "set spec[user = '${foreman_proxy::user}']/host_group/command[2] '${foreman_proxy::puppetrun_cmd} *'",
        "set spec[user = '${foreman_proxy::user}']/host_group/command[1]/tag NOPASSWD",
        "set Defaults[type = ':${foreman_proxy::user}']/type :${foreman_proxy::user}",
        "set Defaults[type = ':${foreman_proxy::user}']/requiretty/negate ''",
      ],
    }
  }
}
