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
  $collections_paths = ['/etc/ansible/collections', '/usr/share/ansible/collections']
  # No reports are redirected by default
  $report_type = 'foreman'
  case $facts['os']['family'] {
    'RedHat': {
      $callback = 'theforeman.foreman.foreman'
      $manage_runner_repo = true
      $runner_package_name = 'ansible-runner'
    }
    'Debian': {
      if ($facts['os']['name'] == 'Ubuntu' and versioncmp($facts['os']['release']['major'], '20.04') >= 0) {
        $callback = 'theforeman.foreman.foreman'
      } else {
        $callback = 'foreman'
      }
      $manage_runner_repo = false
      $runner_package_name = 'python3-ansible-runner'
    }
    default: {
      $callback = 'foreman'
      $manage_runner_repo = false
      $runner_package_name = 'ansible-runner'
    }
  }
}
