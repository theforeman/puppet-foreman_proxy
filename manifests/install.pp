class foreman_proxy::install {
  foreman::install::repos { 'foreman_proxy':
    repo    => $foreman_proxy::repo,
  }

  package {'foreman-proxy':
    ensure  => present,
    require => Foreman::Install::Repos['foreman_proxy'],
  }
}
