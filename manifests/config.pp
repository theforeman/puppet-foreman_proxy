# Configure the foreman proxy
class foreman_proxy::config {

  # Ensure SSL certs from the puppetmaster are available
  # Relationship is duplicated there as defined() is parse-order dependent
  if $foreman_proxy::ssl and defined(Class['puppet::server::config']) {
    Class['puppet::server::config'] -> Class['foreman_proxy::config']
  }

  if $foreman_proxy::puppetca  { include foreman_proxy::puppetca }
  if $foreman_proxy::tftp      { include foreman_proxy::tftp }

  # Somehow, calling these DHCP and DNS seems to conflict. So, they get a prefix...
  if $foreman_proxy::dhcp and $foreman_proxy::dhcp_managed { include foreman_proxy::proxydhcp }

  if $foreman_proxy::dns and $foreman_proxy::dns_managed {
    include foreman_proxy::proxydns
    include dns::params
    $groups = [$dns::params::group,$foreman_proxy::puppet_group]
  } else {
    $groups = [$foreman_proxy::puppet_group]
  }

  user { $foreman_proxy::user:
    ensure  => 'present',
    shell   => '/bin/false',
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
      mode    => '0440',
      content => "${foreman_proxy::user} ALL = NOPASSWD : ${foreman_proxy::puppetca_cmd} *, ${foreman_proxy::puppetrun_cmd} *
Defaults:${foreman_proxy::user} !requiretty\n",
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
