# Default parameters for the Pulp smart proxy plugin
class foreman_proxy::plugin::abrt::params {
  $enabled                 = true
  $listen_on               = 'https'
  $group                   = undef
  $abrt_send_log_file      = '/var/log/foreman-proxy/abrt-send.log'
  $spooldir                = '/var/spool/foreman-proxy-abrt'
  $aggregate_reports       = true
  $send_period             = 600
  $faf_server_url          = undef
  $faf_server_ssl_noverify = true
  $faf_server_ssl_cert     = undef
  $faf_server_ssl_key      = undef
  $version                 = undef
}
