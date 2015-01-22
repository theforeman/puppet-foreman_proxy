# Installs a smart proxy plugin package
define foreman_proxy::plugin(
  $version = $foreman_proxy::plugin_version,
  $package = "${foreman_proxy::plugin_prefix}${title}",
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
