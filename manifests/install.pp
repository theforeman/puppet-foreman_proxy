class foreman_proxy::install {
  include foreman::params
  include foreman::install::repos
  package {'foreman-proxy':
    ensure  => present,
    require => Class['foreman::install::repos'],
  }
}
