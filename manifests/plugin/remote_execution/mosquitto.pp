# = Foreman Proxy Remote Execution Mosquitto Configuration
#
# This class configures mosquitto for use by Remote Execution pull transport
#
# === Parameters:
#
# $ssl_ca::                     SSL CA to validate the client certificates used to access mosquitto
#
# $ssl_cert::                   SSL certificate to be used to run mosquitto via SSL.
#
# $ssl_key::                    Corresponding key to a ssl_cert certificate
#
# === Advanced parameters:
#
# $ensure::                     Enable or disable mosquitto configuration and presence
#
# $port::                       Port mosquitto will run on
#
# $require_certificate::        When true the client must provide a valid certificate in order to connect successfully
#
# $use_identity_as_username::   Use the CN value from the client certificate as a username
#
class foreman_proxy::plugin::remote_execution::mosquitto (
  Enum['absent', 'present'] $ensure = 'present',
  Stdlib::Port $port = 1883,
  Stdlib::Absolutepath $ssl_ca = undef,
  Stdlib::Absolutepath $ssl_cert = undef,
  Stdlib::Absolutepath $ssl_key = undef,
  Boolean $require_certificate = true,
  Boolean $use_identity_as_username = true,
) {
  $mosquitto_config_dir = '/etc/mosquitto'
  $mosquitto_ssl_dir = "${mosquitto_config_dir}/ssl"
  $broker = $facts['networking']['fqdn']

  class { 'mosquitto':
    package_name   => 'mosquitto',
    package_ensure => $ensure,
    service_ensure => bool2str($ensure == 'present', 'running', 'stopped'),
    service_enable => $ensure == 'present',
    config         => [
      "listener ${port}",
      "acl_file ${mosquitto_config_dir}/foreman.acl",
      "cafile ${mosquitto_ssl_dir}/ssl_ca.pem",
      "certfile ${mosquitto_ssl_dir}/ssl_cert.pem",
      "keyfile ${mosquitto_ssl_dir}/ssl_key.pem",
      "require_certificate ${require_certificate}",
      "use_identity_as_username ${use_identity_as_username}",
    ],
  }

  file { "${mosquitto_config_dir}/foreman.acl":
    ensure  => $ensure,
    content => epp(
      "${module_name}/plugin/foreman.acl.epp",
      { user => $facts['networking']['fqdn'] }
    ),
    owner   => 'root',
    group   => 'mosquitto',
    mode    => '0640',
  }

  file { $mosquitto_ssl_dir:
    ensure => bool2str($ensure == 'present', 'directory', 'absent'),
    force  => true,
    owner  => 'root',
    group  => 'mosquitto',
    mode   => '0755',
  }

  file { "${mosquitto_ssl_dir}/ssl_cert.pem":
    ensure => $ensure,
    source => $ssl_cert,
    owner  => 'root',
    group  => 'mosquitto',
    mode   => '0440',
  }

  file { "${mosquitto_ssl_dir}/ssl_key.pem":
    ensure => $ensure,
    source => $ssl_key,
    owner  => 'root',
    group  => 'mosquitto',
    mode   => '0440',
  }

  file { "${mosquitto_ssl_dir}/ssl_ca.pem":
    ensure => $ensure,
    source => $ssl_ca,
    owner  => 'root',
    group  => 'mosquitto',
    mode   => '0440',
  }

  # Ensure certs were deployed before we try to source them
  # This is a workaround for https://tickets.puppetlabs.com/browse/PUP-3399
  File <| title == $ssl_cert |> ~> File["${mosquitto_ssl_dir}/ssl_cert.pem"]
  File <| title == $ssl_key |> ~> File["${mosquitto_ssl_dir}/ssl_key.pem"]
  File <| title == $ssl_ca |> ~> File["${mosquitto_ssl_dir}/ssl_ca.pem"]
}
