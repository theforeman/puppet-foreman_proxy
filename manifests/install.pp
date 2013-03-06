class foreman_proxy::install {
  if ! $foreman_proxy::custom_repo {
    foreman::install::repos { 'foreman_proxy':
      repo    => $foreman_proxy::repo,
    }
  }

  $repo = $foreman_proxy::custom_repo ? {
    true    => [],
    default => Foreman::Install::Repos['foreman_proxy'],
  }

  package {'foreman-proxy':
    ensure  => present,
    require => $repo,
  }
}
