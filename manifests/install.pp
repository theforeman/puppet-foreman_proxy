# Install the foreman proxy
class foreman_proxy::install {
  if ! $foreman_proxy::custom_repo {
    foreman::repos { 'foreman_proxy':
      repo     => $foreman_proxy::repo,
      gpgcheck => $foreman_proxy::gpgcheck,
    }
  }

  $repo = $foreman_proxy::custom_repo ? {
    true    => [],
    default => Foreman::Repos['foreman_proxy'],
  }

  package {'foreman-proxy':
    ensure  => $foreman_proxy::version,
    require => $repo,
  }

  if $foreman_proxy::register_in_foreman {
    package { $foreman_proxy::params::foreman_api_package:
      ensure  => present,
      require => $repo,
    }
  }

  if $foreman_proxy::bmc and $foreman_proxy::bmc_default_provider != 'shell' {
    ensure_packages([$foreman_proxy::bmc_default_provider], { ensure => $foreman_proxy::ensure_packages_version, })
  }
}
