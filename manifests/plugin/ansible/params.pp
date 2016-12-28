# Ansible proxy default parameters
class foreman_proxy::plugin::ansible::params {
  $enabled     = true
  $listen_on   = 'https'
  $ansible_dir = '/etc/ansible'
  $working_dir = '/tmp'
}
