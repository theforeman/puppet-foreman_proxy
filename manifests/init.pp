class foreman_proxy (
  $use_testing       = $foreman_proxy::params::use_testing,
  $dir               = $foreman_proxy::params::dir,
  $user              = $foreman_proxy::params::user,
  $log               = $foreman_proxy::params::log,
  $puppetca          = $foreman_proxy::params::puppetca,
  $autosign_location = $foreman_proxy::params::autosign_location,
  $puppetca_cmd      = $foreman_proxy::params::puppetca_cmd,
  $puppet_group      = $foreman_proxy::params::puppet_group,
  $puppetrun         = $foreman_proxy::params::puppetrun,
  $puppetrun_cmd     = $foreman_proxy::params::puppetrun_cmd,
  $tftp              = $foreman_proxy::params::tftp,
  $syslinux_root     = $foreman_proxy::params::syslinux_root,
  $syslinux_files    = $foreman_proxy::params::syslinux_files,
  $tftproot          = $foreman_proxy::params::tftproot,
  $tftp_dir          = $foreman_proxy::params::tftp_dir,
  $servername        = $foreman_proxy::params::servername,
  $dhcp              = $foreman_proxy::params::dhcp,
  $dhcp_interface    = $foreman_proxy::params::dhcp_interface,
  $dhcp_reverse      = $foreman_proxy::params::dhcp_reverse,
  $gateway           = $foreman_proxy::params::gateway,
  $range             = $foreman_proxy::params::range,
  $dhcp_nameservers  = $foreman_proxy::params::nameservers,
  $dhcp_vendor       = $foreman_proxy::params::dhcp_vendor,
  $dhcp_config       = $foreman_proxy::params::dhcp_config,
  $dhcp_leases       = $foreman_proxy::params::dhcp_leases,
  $dns               = $foreman_proxy::params::dns,
  $dns_interface     = $foreman_proxy::params::dns_interface,
  $dns_reverse       = $foreman_proxy::params::dns_reverse,
  $dns_server        = $foreman_proxy::params::dns_server,
  $keyfile           = $foreman_proxy::params::keyfile
) inherits foreman_proxy::params {
  class { 'foreman_proxy::install': } ~>
  class { 'foreman_proxy::config': } ~>
  class { 'foreman_proxy::service': }
}
