# Install, configure and run a foreman proxy
class foreman_proxy (
  $repo                = $foreman_proxy::params::repo,
  $custom_repo         = $foreman_proxy::params::custom_repo,
  $port                = $foreman_proxy::params::port,
  $dir                 = $foreman_proxy::params::dir,
  $user                = $foreman_proxy::params::user,
  $log                 = $foreman_proxy::params::log,
  $ssl                 = $foreman_proxy::params::ssl,
  $ssl_ca              = $foreman_proxy::params::ssl_ca,
  $ssl_cert            = $foreman_proxy::params::ssl_cert,
  $ssl_key             = $foreman_proxy::params::ssl_key,
  $trusted_hosts       = $foreman_proxy::params::trusted_hosts,
  $manage_sudoersd     = $foreman_proxy::params::manage_sudoersd,
  $use_sudoersd        = $foreman_proxy::params::use_sudoersd,
  $puppetca            = $foreman_proxy::params::puppetca,
  $ssldir              = $foreman_proxy::params::ssldir,
  $puppetdir           = $foreman_proxy::params::puppetdir,
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
  $dhcp_managed        = $foreman_proxy::params::dhcp_managed,
  $dhcp_interface      = $foreman_proxy::params::dhcp_interface,
  $dhcp_gateway        = $foreman_proxy::params::dhcp_gateway,
  $dhcp_range          = $foreman_proxy::params::dhcp_range,
  $dhcp_nameservers    = $foreman_proxy::params::dhcp_nameservers,
  $dhcp_vendor         = $foreman_proxy::params::dhcp_vendor,
  $dhcp_config         = $foreman_proxy::params::dhcp_config,
  $dhcp_leases         = $foreman_proxy::params::dhcp_leases,
  $dhcp_key_name       = $foreman_proxy::params::dhcp_key_name,
  $dhcp_key_secret     = $foreman_proxy::params::dhcp_key_secret,
  $dns                 = $foreman_proxy::params::dns,
  $dns_interface       = $foreman_proxy::params::dns_interface,
  $dns_reverse         = $foreman_proxy::params::dns_reverse,
  $dns_server          = $foreman_proxy::params::dns_server,
  $dns_forwarders      = $foreman_proxy::params::dns_forwarders,
  $keyfile             = $foreman_proxy::params::keyfile
) inherits foreman_proxy::params {
  # Validate misc params
  validate_bool($ssl, $manage_sudoersd, $use_sudoersd)
  validate_array($trusted_hosts)

  # Validate puppet params
  validate_bool($puppetca, $puppetrun)
  validate_string($ssldir, $puppetdir, $autosign_location, $puppetca_cmd, $puppetrun_cmd)

  # Validate tftp params
  validate_bool($tftp)

  # Validate dhcp params
  validate_bool($dhcp, $dhcp_managed)

  # Validate dns params
  validate_bool($dns)
  validate_string($dns_interface, $dns_reverse, $dns_server, $keyfile)
  validate_array($dns_forwarders)

  class { 'foreman_proxy::install': } ~>
  class { 'foreman_proxy::config': } ~>
  class { 'foreman_proxy::service': }
}
