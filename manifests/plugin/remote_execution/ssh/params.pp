# Remote Execution SSH default parameters
class foreman_proxy::plugin::remote_execution::ssh::params {
  include ::foreman_proxy::params

  $enabled            = true
  $listen_on          = 'https'
  $local_working_dir  = '/var/tmp'
  $remote_working_dir = '/var/tmp'
  $generate_keys      = true
  $install_key        = false
  $ssh_identity_dir   = "${::foreman_proxy::params::dir}/.ssh"
  $ssh_identity_file  = 'id_rsa_foreman_proxy'
  $ssh_keygen         = '/usr/bin/ssh-keygen'
  $ssh_kerberos_auth  = false
  $async_ssh          = false
}
