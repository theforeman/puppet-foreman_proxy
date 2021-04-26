# @summary Ansible proxy default parameters
# @api private
class foreman_proxy::plugin::ansible::params {
  include foreman_proxy::params

  $enabled     = true
  $listen_on   = 'https'
  $ansible_dir = $foreman_proxy::params::dir
  $working_dir = '/tmp'
  $host_key_checking = false
  $stdout_callback = 'yaml'
  $roles_path = ['/etc/ansible/roles', '/usr/share/ansible/roles']
  $ssh_args = '-o ProxyCommand=none -C -o ControlMaster=auto -o ControlPersist=60s'
  $install_runner = true
  $manage_runner_repo = true
  case $facts['os']['family'] {
    'RedHat': {
      $callback = 'theforeman.foreman.foreman'
    }
    'Debian': {
      $callback = 'foreman'
    }
    default: {
      $callback = 'foreman'
    }
  }
}
