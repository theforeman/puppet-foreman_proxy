# Default parameters for the Salt smart proxy plugin
class foreman_proxy::plugin::salt::params {
  $enabled           = true
  $listen_on         = 'https'
  $autosign_file     = '/etc/salt/autosign.conf'
  $user              = 'root'
  $group             = undef

  $api               = false
  $api_url           = 'https://localhost:8080'
  $api_auth          = 'pam'
  $api_username      = 'saltuser'
  $api_password      = 'saltpassword'
}
