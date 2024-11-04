# @summary Install the foreman proxy
# @api private
class foreman_proxy::install {
  package { 'foreman-proxy':
    ensure => $foreman_proxy::version,
  }

  if $foreman_proxy::log == 'JOURNAL' {
    package { 'foreman-proxy-journald':
      ensure => installed,
    }
  }

  if $foreman_proxy::register_in_foreman {
    contain foreman::providers
  }

  if $foreman_proxy::bmc and !($foreman_proxy::bmc_default_provider in ['shell', 'redfish']) {
    stdlib::ensure_packages([$foreman_proxy::bmc_default_provider], { ensure => $foreman_proxy::ensure_packages_version, })
  }

  if $foreman_proxy::dns and $foreman_proxy::dns_provider in ['nsupdate', 'nsupdate_gss'] {
    stdlib::ensure_packages([$foreman_proxy::nsupdate], { ensure => $foreman_proxy::ensure_packages_version })
  }
}
