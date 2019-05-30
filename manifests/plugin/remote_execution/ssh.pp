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
  Boolean $enabled = $::foreman_proxy::plugin::remote_execution::ssh::params::enabled,
  Foreman_proxy::ListenOn $listen_on = $::foreman_proxy::plugin::remote_execution::ssh::params::listen_on,
  Boolean $generate_keys = $::foreman_proxy::plugin::remote_execution::ssh::params::generate_keys,
  Boolean $install_key = $::foreman_proxy::plugin::remote_execution::ssh::params::install_key,
  Stdlib::Absolutepath $ssh_identity_dir = $::foreman_proxy::plugin::remote_execution::ssh::params::ssh_identity_dir,
  String $ssh_identity_file = $::foreman_proxy::plugin::remote_execution::ssh::params::ssh_identity_file,
  String $ssh_keygen = $::foreman_proxy::plugin::remote_execution::ssh::params::ssh_keygen,
  Stdlib::Absolutepath $local_working_dir = $::foreman_proxy::plugin::remote_execution::ssh::params::local_working_dir,
  Stdlib::Absolutepath $remote_working_dir = $::foreman_proxy::plugin::remote_execution::ssh::params::remote_working_dir,
  Boolean $ssh_kerberos_auth = $::foreman_proxy::plugin::remote_execution::ssh::params::ssh_kerberos_auth,
  Boolean $async_ssh = $::foreman_proxy::plugin::remote_execution::ssh::params::async_ssh,
) inherits foreman_proxy::plugin::remote_execution::ssh::params {

  $ssh_identity_path = "${ssh_identity_dir}/${ssh_identity_file}"

  include ::foreman_proxy::plugin::dynflow

  foreman_proxy::plugin { 'remote_execution_ssh':
  }
  -> foreman_proxy::settings_file { 'remote_execution_ssh':
    enabled       => $enabled,
    listen_on     => $listen_on,
    template_path => 'foreman_proxy/plugin/remote_execution_ssh.yml.erb',
  }

  if $ssh_kerberos_auth {
    if $::osfamily == 'RedHat' {
      if versioncmp($facts['operatingsystemmajrelease'], '8') >= 0 {
        $ruby_prefix = 'rubygem'
      } else {
        $ruby_prefix = 'tfm-rubygem'
      }
    } else {
      $ruby_prefix = 'ruby'
    }

    $kerberos_pkg = "${ruby_prefix}-net-ssh-krb"
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

  if $::osfamily == 'RedHat' and $::operatingsystem != 'Fedora' {
    if $ssh_kerberos_auth {
      Package[$kerberos_pkg] ~> Service['smart_proxy_dynflow_core']
    }
    Foreman_proxy::Settings_file['remote_execution_ssh'] ~> Service['smart_proxy_dynflow_core']
  }
}
