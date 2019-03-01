# This class replicates the functionality of the remote_execution_ssh_keys community templates snippet
#
# === Parameters:
#
# $manage_user::           Whether to manage the ssh user.  Defaults to the host's Foreman ENC parameter `remote_execution_create_user`.
#
# $ssh_user::              The ssh user name. Defaults to the host's Foreman ENC parameter `remote_execution_ssh_user`.
#
# $effective_user_method:: Method to switch from ssh user to effective user.  Defaults to the host's Foreman ENC parameter `remote_execution_effective_user_method`.
#
# $ssh_keys::              An array of public keys to put in ~/.ssh/authorized_keys.  Defaults to the host's Foreman ENC parameter `remote_execution_ssh_keys`.
#
class foreman_proxy::plugin::remote_execution::ssh_user (
  Boolean            $manage_user           = $foreman_proxy::plugin::remote_execution::ssh_user::params::manage_user,
  String[1]          $ssh_user              = $foreman_proxy::plugin::remote_execution::ssh_user::params::ssh_user,
  Enum['sudo', 'su'] $effective_user_method = $foreman_proxy::plugin::remote_execution::ssh_user::params::effective_user_method,
  Array[String[1]]   $ssh_keys              = $foreman_proxy::plugin::remote_execution::ssh_user::params::ssh_keys,
) inherits foreman_proxy::plugin::remote_execution::ssh_user::params {

  # Manage the user
  if $manage_user and $ssh_user != 'root'{
    user { $ssh_user:
      ensure           => present,
      home             => "/home/${ssh_user}",
      managehome       => true,
      expiry           => absent,
      password_max_age => -1, # password never expires
      password         => '!!',
      purge_ssh_keys   => true,
    }
  }

  # Manage the user's keys
  $ssh_keys.each |String $ssh_key| {
    $key_array = split($ssh_key, ' ')
    $key_type  = $key_array[0]
    $key       = $key_array[1]
    $key_name  = $key_array[2]

    ssh_authorized_key { $key_name:
      ensure => present,
      user   => $ssh_user,
      type   => $key_type,
      key    => $key,
    }
  }

  # Manage the sudo configuration
  if $ssh_user != 'root' and $effective_user_method == 'sudo' {
    # Clean up file created by the provisioning template
    file { "/etc/sudoers.d/${ssh_user}":
      ensure => absent,
    }

    $content = "${ssh_user} ALL = (root) NOPASSWD : ALL\nDefaults:${ssh_user} !requiretty\n"

    # saz/sudo is a very popular module
    # If it's in the environment, go ahead and use it
    if extlib::has_module('saz/sudo') {
      sudo::conf { 'foreman-proxy-rex':
        content => $content,
      }
    } else {
      include foreman_proxy::params
      file { "${foreman_proxy::params::sudoers}.d/foreman-proxy-rex":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0440',
        content => $content,
      }
    }
  }
}
