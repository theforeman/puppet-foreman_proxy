# Default parameters for the Dynflow smart proxy plugin
class foreman_proxy::plugin::dynflow::params {
  $enabled           = true
  $listen_on         = 'https'
  $database_path     = '/var/lib/foreman-proxy/dynflow/dynflow.sqlite'
  $console_auth      = true
  $core_listen       = '0.0.0.0'
  $core_port         = 8008
}
