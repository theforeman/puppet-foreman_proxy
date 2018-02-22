# Default parameters for the Dynflow smart proxy plugin
class foreman_proxy::plugin::dynflow::params {
  $enabled               = true
  $listen_on             = 'https'
  # use in-memory sqlite by default for performance reasons
  $database_path         = undef
  $console_auth          = true
  $core_listen           = '0.0.0.0'
  $core_port             = 8008
  $ssl_disabled_ciphers  = undef
  $tls_disabled_versions = undef
  $open_file_limit       = 1000000
}
