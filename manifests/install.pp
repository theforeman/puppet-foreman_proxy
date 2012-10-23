class foreman_proxy::install {
  foreman::install::repos { 'foreman_proxy':
    use_testing    => $foreman_proxy::use_testing,
  }

  package {'foreman-proxy':
    ensure  => present,
    require => Foreman::Install::Repos['foreman_proxy'],
  }
}
