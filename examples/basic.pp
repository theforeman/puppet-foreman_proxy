$directory = '/etc/foreman-proxy'
$certificate = "${directory}/certificate.pem"
$key = "${directory}/key.pem"

# Install a proxy
class { 'foreman_proxy':
  puppet_group        => 'root',
  register_in_foreman => false,
  ssl_ca              => $certificate,
  ssl_cert            => $certificate,
  ssl_key             => $key,
}

# Create the certificates - this is after the proxy because we need the user variable
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
  owner  => $foreman_proxy::user,
  group  => $foreman_proxy::user,
  mode   => '0640',
  before => Class['foreman_proxy::service'],
}
