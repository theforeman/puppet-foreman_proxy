# = Foreman Proxy Remote Execution SSH plugin
#
# This class installs Remote Execution SSH support for Foreman proxy
#
# === Parameters:
#
# $enabled::            Enables/disables the plugin
#                       type:boolean
#
# $listen_on::          Proxy feature listens on https, http, or both
#
# $generate_keys::      Automatically generate SSH keys
#                       type:boolean
#
# $ssh_identity_dir::   Directory where SSH keys are stored
#
# $ssh_identity_file::  Provide an alternative name for the SSH keys
#
# $ssh_keygen::         Location of the ssh-keygen binary
#
# $local_working_dir::  Local working directory on the smart proxy
#
# $remote_working_dir:: Remote working directory on clients
#
class foreman_proxy::plugin::remote_execution::ssh (
  $enabled            = $::foreman_proxy::plugin::remote_execution::ssh::params::enabled,
  $listen_on          = $::foreman_proxy::plugin::remote_execution::ssh::params::listen_on,
  $generate_keys      = $::foreman_proxy::plugin::remote_execution::ssh::params::generate_keys,
  $ssh_identity_dir   = $::foreman_proxy::plugin::remote_execution::ssh::params::ssh_identity_dir,
  $ssh_identity_file  = $::foreman_proxy::plugin::remote_execution::ssh::params::ssh_identity_file,
  $ssh_keygen         = $::foreman_proxy::plugin::remote_execution::ssh::params::ssh_keygen,
  $local_working_dir  = $::foreman_proxy::plugin::remote_execution::ssh::params::local_working_dir,
  $remote_working_dir = $::foreman_proxy::plugin::remote_execution::ssh::params::remote_working_dir,
) inherits foreman_proxy::plugin::remote_execution::ssh::params {

  $ssh_identity_path = "${ssh_identity_dir}/${ssh_identity_file}"

  validate_absolute_path($ssh_identity_path, $local_working_dir, $remote_working_dir)
  validate_bool($enabled, $generate_keys)
  validate_listen_on($listen_on)

  include ::foreman_proxy::plugin::dynflow

  foreman_proxy::plugin { 'remote_execution_ssh':
  } ->
  foreman_proxy::settings_file { 'remote_execution_ssh':
    enabled       => $enabled,
    listen_on     => $listen_on,
    template_path => 'foreman_proxy/plugin/remote_execution_ssh.yml.erb',
  }

  if $generate_keys {
    file { $ssh_identity_dir:
      ensure => directory,
      owner  => $::foreman_proxy::user,
      group  => $::foreman_proxy::user,
      mode   => '0700',
    } ->
    exec { 'generate_ssh_key':
      command => "${ssh_keygen} -f ${ssh_identity_path} -N ''",
      user    => $::foreman_proxy::user,
      cwd     => $ssh_identity_dir,
      creates => $ssh_identity_path,
    }
  }
}
