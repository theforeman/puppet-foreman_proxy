# @summary Install a smart proxy plugin package
#
# @param version
#   The package to ensure. Can be a installed, absent or a specific version
#
# @param package
#   The package to install. Underscores are replaced with dashes on Debian
#
define foreman_proxy::plugin(
  $version = $foreman_proxy::params::plugin_version,
  $package = "${foreman_proxy::params::plugin_prefix}${title}",
) {
  # Debian gem2deb converts underscores to hyphens
  case $::osfamily {
    'Debian': {
      $real_package = regsubst($package,'_','-','G')
    }
    default: {
      $real_package = $package
    }
  }
  package { $real_package:
    ensure => $version,
  }
}
