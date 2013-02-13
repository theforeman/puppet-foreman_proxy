class foreman_proxy::config {

  # Ensure SSL certs from the puppetmaster are available
  # Relationship is duplicated there as defined() is parse-order dependent
  if $foreman_proxy::ssl and defined(Class['puppet::server::config']) {
    Class['puppet::server::config'] -> Class['foreman_proxy::config']
  }

  if $foreman_proxy::puppetca  { include foreman_proxy::puppetca }
  if $foreman_proxy::tftp      { include foreman_proxy::tftp }

  # Somehow, calling these DHCP and DNS seems to conflict. So, they get a prefix...
  if $foreman_proxy::dhcp      { include foreman_proxy::proxydhcp }

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

  include sudo
  sudo::directive {'foreman-proxy':
    ensure => present,
    content => "foreman-proxy ALL = NOPASSWD : ${foreman_proxy::puppetca_cmd} *, ${foreman_proxy::puppetrun_cmd} *
Defaults:foreman-proxy !requiretty\n",
  }

}
