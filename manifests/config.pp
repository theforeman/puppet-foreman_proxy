class foreman_proxy::config {
  user { $foreman_proxy::user:
    ensure  => 'present',
    shell   => '/sbin/nologin',
    comment => 'Foreman Proxy account',
    groups  => $foreman_proxy::puppet_group,
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

  augeas { 'sudo-foreman-proxy':
    context => '/files/etc/sudoers',
    changes => [
      "set spec[user = '${foreman_proxy::user}']/user ${foreman_proxy::user}",
      "set spec[user = '${foreman_proxy::user}']/host_group/host ALL",
      "set spec[user = '${foreman_proxy::user}']/host_group/command[1] '${foreman_proxy::puppetca_cmd}'",
      "set spec[user = '${foreman_proxy::user}']/host_group/command[2] '${foreman_proxy::puppetrun_cmd}'",
      "set spec[user = '${foreman_proxy::user}']/host_group/command[1]/tag NOPASSWD",
      "set Defaults[type = ':${foreman_proxy::user}']/type :${foreman_proxy::user}",
      "set Defaults[type = ':${foreman_proxy::user}']/requiretty/negate ''",
    ],
  }

  if $foreman_proxy::puppetca  { include foreman_proxy::puppetca }
  if $foreman_proxy::tftp      { include foreman_proxy::tftp }

  # Somehow, calling these DHCP and DNS seems to conflict. So, they get a prefix...
  if $foreman_proxy::dhcp      { include foreman_proxy::proxydhcp }
  if $foreman_proxy::dns       { include foreman_proxy::proxydns }

}
