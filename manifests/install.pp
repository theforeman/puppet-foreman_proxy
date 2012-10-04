class foreman_proxy::install {
  include foreman::params

  foreman::install::repos { 'foreman_proxy':
    use_testing    => $foreman_proxy::use_testing,
    package_source => $foreman_proxy::package_source,
  }

  package {'foreman-proxy':
    ensure  => present,
    require => Foreman::Install::Repos['foreman_proxy'],
  }
}
