class foreman_proxy (
  $repo                = $foreman_proxy::params::repo,
  $port                = $foreman_proxy::params::port,
  $dir                 = $foreman_proxy::params::dir,
  $user                = $foreman_proxy::params::user,
  $log                 = $foreman_proxy::params::log,
  $ssl                 = $foreman_proxy::params::ssl,
  $ssl_ca              = $foreman_proxy::params::ssl_ca,
  $ssl_cert            = $foreman_proxy::params::ssl_cert,
  $ssl_key             = $foreman_proxy::params::ssl_key,
  $trusted_hosts       = $foreman_proxy::params::trusted_hosts,
  $manage_sudoers      = $foreman_proxy::params::manage_sudoers,
  $use_sudoersd        = $foreman_proxy::params::use_sudoersd,
  $puppetca            = $foreman_proxy::params::puppetca,
  $autosign_location   = $foreman_proxy::params::autosign_location,
  $puppetca_cmd        = $foreman_proxy::params::puppetca_cmd,
  $puppet_group        = $foreman_proxy::params::puppet_group,
  $puppetrun           = $foreman_proxy::params::puppetrun,
  $puppetrun_cmd       = $foreman_proxy::params::puppetrun_cmd,
  $tftp                = $foreman_proxy::params::tftp,
  $tftp_syslinux_root  = $foreman_proxy::params::tftp_syslinux_root,
  $tftp_syslinux_files = $foreman_proxy::params::tftp_syslinux_files,
  $tftp_root           = $foreman_proxy::params::tftp_root,
  $tftp_dirs           = $foreman_proxy::params::tftp_dirs,
  $tftp_servername     = $foreman_proxy::params::tftp_servername,
  $dhcp                = $foreman_proxy::params::dhcp,
  $dhcp_interface      = $foreman_proxy::params::dhcp_interface,
  $dhcp_gateway        = $foreman_proxy::params::dhcp_gateway,
  $dhcp_range          = $foreman_proxy::params::dhcp_range,
  $dhcp_nameservers    = $foreman_proxy::params::dhcp_nameservers,
  $dhcp_vendor         = $foreman_proxy::params::dhcp_vendor,
  $dhcp_config         = $foreman_proxy::params::dhcp_config,
  $dhcp_leases         = $foreman_proxy::params::dhcp_leases,
  $dns                 = $foreman_proxy::params::dns,
  $dns_interface       = $foreman_proxy::params::dns_interface,
  $dns_reverse         = $foreman_proxy::params::dns_reverse,
  $dns_server          = $foreman_proxy::params::dns_server,
  $dns_forwarders      = $foreman_proxy::params::dns_forwarders,
  $keyfile             = $foreman_proxy::params::keyfile
) inherits foreman_proxy::params {
  class { 'foreman_proxy::install': } ~>
  class { 'foreman_proxy::config': } ~>
  class { 'foreman_proxy::service': }
}
