# Default parameters for the OpenSCAP smart proxy plugin
class foreman_proxy::plugin::openscap::params {
  if $::operatingsystemmajrelease == undef {
    $versions_array = split($::operatingsystemrelease, '\.') # facter 1.6
    $major_version = $versions_array[0]
  } else {
    $major_version = $::operatingsystemmajrelease # facter 1.7+
  }

  $configure_openscap_repo = false
  $enabled                 = true
  $version                 = undef
  $listen_on               = 'https'
  $openscap_send_log_file  = '/var/log/foreman-proxy/openscap-send.log'
  $spooldir                = '/var/spool/foreman-proxy/openscap'
  $contentdir              = '/var/lib/foreman-proxy/openscap/content'
  $reportsdir              = '/var/lib/foreman-proxy/openscap/reports'
  $failed_dir              = '/var/lib/foreman-proxy/openscap/failed'
  $corrupted_dir           = '/var/lib/foreman-proxy/openscap/corrupted'
}
