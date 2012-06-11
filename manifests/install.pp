class foreman_proxy::install {
  class { '::foreman::install::repos': use_testing => $foreman_proxy::params::use_testing }

  package {'foreman-proxy':
    ensure  => present,
    require => Class['foreman::install::repos'],
  }
}
