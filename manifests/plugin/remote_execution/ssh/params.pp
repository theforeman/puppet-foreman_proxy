# Remote Execution SSH default parameters
class foreman_proxy::plugin::remote_execution::ssh::params {
  include ::foreman_proxy::params

  $enabled           = true
  $listen_on         = 'https'
  $generate_keys     = true
  $ssh_identity_dir  = "${::foreman_proxy::params::dir}/.ssh"
  $ssh_identity_file = 'id_rsa_foreman_proxy'
  $ssh_user          = 'root'
  $ssh_keygen        = '/usr/bin/ssh-keygen'
}
