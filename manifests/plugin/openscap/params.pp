# Default parameters for the OpenSCAP smart proxy plugin
class foreman_proxy::plugin::openscap::params {
  $enabled                 = true
  $version                 = undef
  $listen_on               = 'https'
  $openscap_send_log_file  = '/var/log/foreman-proxy/openscap-send.log'
  $spooldir                = '/var/spool/foreman-proxy/openscap'
  $contentdir              = '/var/lib/foreman-proxy/openscap/content'
  $reportsdir              = '/var/lib/foreman-proxy/openscap/reports'
  $failed_dir              = '/var/lib/foreman-proxy/openscap/failed'
  $corrupted_dir           = '/var/lib/foreman-proxy/openscap/corrupted'
  $proxy_name              = undef
}
