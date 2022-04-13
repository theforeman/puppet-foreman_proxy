# = Foreman Proxy Remote Execution Script plugin
#
# This class installs Remote Execution Script support for Foreman proxy
#
# === Parameters:
#
# $mode::                Operation Mode of the plugin.
#
# $cockpit_integration:: Enables/disables Cockpit integration
#
# === SSH parameters:
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
# $ssh_log_level::      Configure ssh client LogLevel
#
# === Advanced parameters:
#
# $enabled::            Enables/disables the plugin
#
# $listen_on::          Proxy feature listens on https, http, or both
#
class foreman_proxy::plugin::remote_execution::script (
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
  Enum['ssh', 'ssh-async', 'pull-mqtt'] $mode = 'ssh',
  Optional[Foreman_proxy::Sshloglevel] $ssh_log_level = undef,
  Boolean $cockpit_integration = true,
) {
  $ssh_identity_path = "${ssh_identity_dir}/${ssh_identity_file}"

  include foreman_proxy::params
  include foreman_proxy::plugin::dynflow

  foreman_proxy::plugin::module { 'remote_execution_ssh':
    enabled   => $enabled,
    feature   => 'Script',
    listen_on => $listen_on,
  }

  if $generate_keys {
    class { 'foreman_proxy::plugin::remote_execution::ssh::keys':
      install_key       => $install_key,
      ssh_identity_path => $ssh_identity_path,
      ssh_keygen        => $ssh_keygen,
      user              => $foreman_proxy::user,
      group             => $foreman_proxy::user,
    }
  }

  if $mode == 'pull-mqtt' {
    class { 'foreman_proxy::plugin::remote_execution::mosquitto':
    }
  }

}
