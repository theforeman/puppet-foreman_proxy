# @summary Ansible proxy default parameters
# @api private
class foreman_proxy::plugin::ansible::params {
  include foreman_proxy::params

  $enabled     = true
  $listen_on   = 'https'
  $ansible_dir = $foreman_proxy::params::dir
  $working_dir = '/tmp'
  $host_key_checking = false
  $roles_path = ['/etc/ansible/roles', '/usr/share/ansible/roles']
  $ssh_args = '-o ProxyCommand=none -C -o ControlMaster=auto -o ControlPersist=60s -o ServerAliveInterval=15 -o ServerAliveCountMax=3'
  $install_runner = true
  $collections_paths = ['/etc/ansible/collections', '/usr/share/ansible/collections']
  case $facts['os']['family'] {
    'RedHat': {
      $callback = 'theforeman.foreman.foreman'
      $runner_package_name = 'ansible-runner'
    }
    'Debian': {
      $callback = 'theforeman.foreman.foreman'
      $runner_package_name = 'python3-ansible-runner'
    }
    default: {
      $callback = 'foreman'
      $runner_package_name = 'ansible-runner'
    }
  }
}
