class { 'foreman::repo':
  repo => 'nightly',
}

# This provides dig which we use in our tests
$dig_package = $facts['os']['family'] ? {
  'Debian' => $facts['os']['name'] ? {
    'Debian' => versioncmp($facts['os']['release']['major'], '13') < 0 ? {
      true    => 'dnsutils',
      default => 'bind9-dnsutils',
    },
    'Ubuntu' => versioncmp($facts['os']['release']['full'], '24.04') < 0 ? {
      true    => 'dnsutils',
      default => 'bind9-dnsutils',
    },
    default => 'bind9-dnsutils',
  },
  default  => 'bind-utils',
}

package { $dig_package:
  ensure => installed,
}

# Create certificates
$certificate_group = 'foreman-proxy'
$directory = '/etc/foreman-proxy'
$certificate = "${directory}/certificate.pem"
$key = "${directory}/key.pem"

group { $certificate_group:
  ensure => present,
}

exec { 'Create certificate directory':
  command => "mkdir -p ${directory}",
  path    => ['/bin', '/usr/bin'],
  creates => $directory,
}
-> exec { 'Generate certificate':
  command => "openssl req -nodes -x509 -newkey rsa:2048 -subj '/CN=${facts['networking']['fqdn']}' -keyout '${key}' -out '${certificate}' -days 365",
  path    => ['/bin', '/usr/bin'],
  creates => $certificate,
  umask   => '0022',
}
-> file { [$key, $certificate]:
  owner => 'root',
  group => $certificate_group,
  mode  => '0640',
}
