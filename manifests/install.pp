# Install the foreman proxy
class foreman_proxy::install {
  if $foreman_proxy::repo {
    foreman::repos { 'foreman_proxy':
      repo     => $foreman_proxy::repo,
      gpgcheck => $foreman_proxy::gpgcheck,
      before   => Package['foreman-proxy'],
    }
  }

  package {'foreman-proxy':
    ensure => $foreman_proxy::version,
  }

  if $foreman_proxy::log == 'JOURNALD' {
    package { 'foreman-proxy-journald':
      ensure => installed,
    }
  }

  if $foreman_proxy::register_in_foreman {
    contain foreman::providers
    if $foreman_proxy::repo {
      Foreman::Repos['foreman_proxy'] -> Class['foreman::providers']
    }
  }

  if $foreman_proxy::bmc and $foreman_proxy::bmc_default_provider != 'shell' {
    ensure_packages([$foreman_proxy::bmc_default_provider], { ensure => $foreman_proxy::ensure_packages_version, })
  }
}
