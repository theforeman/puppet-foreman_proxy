# Ansible proxy default parameters
class foreman_proxy::plugin::ansible::params {
  $enabled     = true
  $listen_on   = 'https'
  $ansible_dir = '/usr/share/foreman-proxy'
  $working_dir = '/tmp'
  $host_key_checking = false
  $stdout_callback = 'yaml'
  $roles_path = ['/etc/ansible/roles', '/usr/share/ansible/roles']
}
