# = Foreman Proxy Remote Execution SSH plugin
#
# This class installs Remote Execution SSH support for Foreman proxy
#
# === Parameters:
#
# $generate_keys::      Automatically generate SSH keys
#
# $install_key::        Automatically install generated SSH key to root authorized keys
#                       which allows managing this host through Remote Execution
#
# $ssh_identity_dir::   Directory where SSH keys are stored
#
# $ssh_identity_file::  Provide an alternative name for the SSH keys
#
# $ssh_keygen::         Location of the ssh-keygen binary
#
# $ssh_kerberos_auth::  Enable kerberos authentication for SSH
#
# $local_working_dir::  Local working directory on the smart proxy
#
# $remote_working_dir:: Remote working directory on clients
#
# === Advanced parameters:
#
# $enabled::            Enables/disables the plugin
#
# $listen_on::          Proxy feature listens on https, http, or both
#
# $async_ssh::          Whether to run remote execution jobs asynchronously.
#
class foreman_proxy::plugin::remote_execution::ssh (
  Boolean $enabled = true,
  Foreman_proxy::ListenOn $listen_on = 'https',
  Boolean $generate_keys = true,
  Boolean $install_key = false,
  Stdlib::Absolutepath $ssh_identity_dir = '/var/lib/foreman-proxy/ssh',
  String $ssh_identity_file = 'id_rsa_foreman_proxy',
  String $ssh_keygen = '/usr/bin/ssh-keygen',
  Stdlib::Absolutepath $local_working_dir = '/var/tmp',
  Stdlib::Absolutepath $remote_working_dir = '/var/tmp',
  Boolean $ssh_kerberos_auth = false,
  Boolean $async_ssh = false,
) {

  $ssh_identity_path = "${ssh_identity_dir}/${ssh_identity_file}"

  include foreman_proxy::params
  include ::foreman_proxy::plugin::dynflow

  foreman_proxy::plugin { 'remote_execution_ssh':
  }
  -> foreman_proxy::settings_file { 'remote_execution_ssh':
    enabled       => $enabled,
    feature       => 'SSH',
    listen_on     => $listen_on,
    template_path => 'foreman_proxy/plugin/remote_execution_ssh.yml.erb',
  }

  if $ssh_kerberos_auth {
    $kerberos_pkg = "${foreman_proxy::params::ruby_package_prefix}net-ssh-krb"
    package { $kerberos_pkg:
      ensure => present,
    }
  }

  if $generate_keys {
    file { $ssh_identity_dir:
      ensure => directory,
      owner  => $::foreman_proxy::user,
      group  => $::foreman_proxy::user,
      mode   => '0700',
    }
    -> exec { 'generate_ssh_key':
      command => "${ssh_keygen} -f ${ssh_identity_path} -N ''",
      user    => $::foreman_proxy::user,
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

  if $foreman_proxy::plugin::dynflow::external_core {
    if $ssh_kerberos_auth {
      Package[$kerberos_pkg] ~> Service['smart_proxy_dynflow_core']
    }
    Foreman_proxy::Settings_file['remote_execution_ssh'] ~> Service['smart_proxy_dynflow_core']
  }
}
