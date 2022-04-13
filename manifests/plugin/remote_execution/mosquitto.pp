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
# $port::                       Port mosquitto will run on
#
# $require_certificate::        When true the client must provide a valid certificate in order to connect successfully
#
# $use_identity_as_username::   Use the CN value from the client certificate as a username
#
class foreman_proxy::plugin::remote_execution::mosquitto (
  Stdlib::Port $port = 1883,
  Stdlib::Absolutepath $ssl_ca = $foreman_proxy::ssl_ca,
  Stdlib::Absolutepath $ssl_cert = $foreman_proxy::ssl_cert,
  Stdlib::Absolutepath $ssl_key = $foreman_proxy::ssl_key,
  Boolean $require_certificate = true,
  Boolean $use_identity_as_username = true,
) {
  $mosquitto_config_dir = '/etc/mosquitto'
  $mosquitto_ssl_dir = "${mosquitto_config_dir}/ssl"

  class { 'mosquitto':
    package_name => 'mosquitto',
    config       => [
      "listener ${port}",
      "acl_file ${mosquitto_config_dir}/foreman.acl",
      "cafile ${mosquitto_ssl_dir}/ssl_ca.pem",
      "certfile ${mosquitto_ssl_dir}/ssl_cert.pem",
      "keyfile ${mosquitto_ssl_dir}/ssl_key.pem",
      "require_certificate ${require_certificate}",
      "use_identity_as_username ${use_identity_as_username}",
    ],
  }

  file { $mosquitto_config_dir:
    ensure  => directory,
    owner   => 'root',
    group   => 'mosquitto',
    mode    => '0755',
    require => Package['mosquitto'],
  }

  file { "${mosquitto_config_dir}/foreman.acl":
    ensure  => 'file',
    content => epp(
      "${module_name}/plugin/foreman.acl.epp",
      { user => $facts['networking']['fqdn'] }
    ),
    owner   => 'root',
    group   => 'mosquitto',
    mode    => '0640',
  }

  file { $mosquitto_ssl_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'mosquitto',
    mode   => '0755',
  }

  file { "${mosquitto_ssl_dir}/ssl_cert.pem":
    ensure  => 'file',
    content => file($ssl_cert),
    owner   => 'root',
    group   => 'mosquitto',
    mode    => '0440',
  }

  file { "${mosquitto_ssl_dir}/ssl_key.pem":
    ensure  => 'file',
    content => file($ssl_key),
    owner   => 'root',
    group   => 'mosquitto',
    mode    => '0440',
  }

  file { "${mosquitto_ssl_dir}/ssl_ca.pem":
    ensure  => 'file',
    content => file($ssl_ca),
    owner   => 'root',
    group   => 'mosquitto',
    mode    => '0440',
  }
}
