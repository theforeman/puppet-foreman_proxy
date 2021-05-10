# @summary Install the foreman proxy
# @api private
class foreman_proxy::install {
  if $foreman_proxy::repo {
    foreman::repos { 'foreman_proxy':
      repo             => $foreman_proxy::repo,
      gpgcheck         => $foreman_proxy::gpgcheck,
      yum_repo_baseurl => $foreman_proxy::yum_repo_baseurl,
      before           => Package['foreman-proxy'],
    }
  }

  package {'foreman-proxy':
    ensure => $foreman_proxy::version,
  }

  if $foreman_proxy::log == 'JOURNAL' {
    package { 'foreman-proxy-journald':
      ensure => installed,
    }
    if $foreman_proxy::repo {
      Foreman::Repos['foreman_proxy'] -> Package['foreman-proxy-journald']
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

  if $foreman_proxy::dns and $foreman_proxy::dns_provider in ['nsupdate', 'nsupdate_gss'] {
    ensure_packages([$foreman_proxy::nsupdate], { ensure => $foreman_proxy::ensure_packages_version })
  }
}
