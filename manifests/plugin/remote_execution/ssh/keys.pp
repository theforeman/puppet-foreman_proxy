# = Foreman Proxy Remote Execution SSH plugin key management
#
# This class generates and installs Remote Execution SSH keys for Foreman proxy
#
# === Parameters:
#
# $install_key::        Automatically install generated SSH key to root authorized keys
#                       which allows managing this host through Remote Execution
#
# $ssh_identity_path::  Fully qualified path where SSH keys are stored
#
# $ssh_keygen::         Location of the ssh-keygen binary
#
# $user::               User owner of the directory and keys.
#
# $group::              Group owner of the directory and keys.
#
class foreman_proxy::plugin::remote_execution::ssh::keys (
  Boolean $install_key = false,
  Stdlib::Absolutepath $ssh_identity_path = '/var/lib/foreman-proxy/ssh/id_rsa_foreman_proxy',
  String $ssh_keygen = '/usr/bin/ssh-keygen',
  String $user = 'foreman-proxy',
  String $group = 'foreman-proxy',
) {
  $ssh_identity_dir = dirname($ssh_identity_path)

  file { $ssh_identity_dir:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0700',
  }
  -> exec { 'generate_ssh_key':
    command => "${ssh_keygen} -f ${ssh_identity_path} -N '' -m pem",
    user    => $user,
    cwd     => $ssh_identity_dir,
    creates => $ssh_identity_path,
  }
  if $install_key {
    # Ensure the .ssh directory exists with the right permissions
    file { '/root/.ssh':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0700',
    }
    -> exec { 'install_ssh_key':
      path    => '/usr/bin:/usr/sbin:/bin',
      command => "cat ${ssh_identity_path}.pub >> /root/.ssh/authorized_keys",
      unless  => "grep -f ${ssh_identity_path}.pub /root/.ssh/authorized_keys",
      require => Exec['generate_ssh_key'],
    }
  }
}
