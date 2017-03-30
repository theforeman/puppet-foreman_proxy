class foreman_proxy::plugin::dhcp::remote_isc::params {
  $dhcp_config     = '/etc/dhcp/dhcpd.conf'
  $dhcp_leases     = '/var/lib/dhcpd/dhcpd.leases'
  $key_name        = undef
  $key_secret      = undef
  $omapi_port      = 7911
}
