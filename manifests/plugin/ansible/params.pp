# @summary Ansible proxy default parameters
# @api private
class foreman_proxy::plugin::ansible::params {
  $enabled     = true
  $listen_on   = 'https'
  $ansible_dir = '/usr/share/foreman-proxy'
  $working_dir = '/tmp'
  $host_key_checking = false
  $stdout_callback = 'yaml'
  $roles_path = ['/etc/ansible/roles', '/usr/share/ansible/roles']
  $ssh_args = '-o ProxyCommand=none -C -o ControlMaster=auto -o ControlPersist=60s'
  $install_runner = true
  $manage_runner_repo = true
}
