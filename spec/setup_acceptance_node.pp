class { 'foreman::repo':
  repo => 'nightly',
}

# This provides dig which we use in our tests
$dig_package = $facts['os']['family'] ? {
  'Debian' => 'dnsutils',
  default  => 'bind-utils',
}

package { $dig_package:
  ensure => installed,
}
