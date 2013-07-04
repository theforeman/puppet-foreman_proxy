# Install the foreman proxy
class foreman_proxy::install {
  if ! $foreman_proxy::custom_repo {
    foreman::install::repos { 'foreman_proxy':
      repo     => $foreman_proxy::repo,
      gpgcheck => $foreman_proxy::gpgcheck,
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

  $foreman_api_package = $osfamily ? {
    Debian  => "ruby-foreman-api",
    default => "rubygem-foreman_api",
  }

  package { $foreman_api_package:
    ensure  => present,
    require => $repo,
  }
}
