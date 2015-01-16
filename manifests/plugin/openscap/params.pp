# Default parameters for the OpenSCAP smart proxy plugin
class foreman_proxy::plugin::openscap::params {
  $enabled                 = true
  $openscap_send_log_file  = '/var/log/foreman-proxy/openscap-send.log'
  $spooldir                = '/var/spool/foreman-proxy/openscap'
}
