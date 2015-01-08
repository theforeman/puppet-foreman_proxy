# Default parameters for the Salt smart proxy plugin
class foreman_proxy::plugin::salt::params {
  $enabled           = true
  $listen_on         = 'https'
  $autosign_file     = '/etc/salt/autosign.conf'
  $user              = 'root'
  $group             = undef
}
