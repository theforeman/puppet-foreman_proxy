# Default parameters for the Salt smart proxy plugin
# @api private
class foreman_proxy::plugin::salt::params {
  include foreman_proxy::params

  $enabled       = true
  $listen_on     = 'https'
  $autosign_file = "${foreman_proxy::params::etc}/salt/autosign.conf"
  $autosign_grains_dir = '/var/lib/foreman-proxy/salt/grains'
  $autosign_key_file = "${autosign_grains_dir}/autosign_key"
  $user          = 'root'

  $api           = false
  $api_url       = 'https://localhost:8080'
  $api_auth      = 'pam'
  $api_username  = 'saltuser'
  $api_password  = 'saltpassword'
  $api_interfaces = ['runner']
  $saltfile      = undef
}
