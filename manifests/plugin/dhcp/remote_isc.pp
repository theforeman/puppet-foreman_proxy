# = Foreman Proxy Remote ISC DHCP
#
# This class installs Remote ISC DHCPD plugin for Foreman proxy
#
# === Parameters:
#
# $dhcp_config::            DHCP config file path
#                           type:Stdlib::Absolutepath
#
# $dhcp_leases::            DHCP leases file
#                           type:Stdlib::Absolutepath
# 
# $key_name::               DHCP key name
#                           type:Optional[String]
# 
# $key_secret::             DHCP password
#                           type:Optional[String]
# 
# $omapi_port::             DHCP server OMAPI port
#                           type:Integer[0, 65535]
#
class foreman_proxy::plugin::dhcp::remote_isc (
  $dhcp_config     = $::foreman_proxy::plugin::dhcp::remote_isc::params::dhcp_config,
  $dhcp_leases     = $::foreman_proxy::plugin::dhcp::remote_isc::params::dhcp_leases,
  $key_name        = $::foreman_proxy::plugin::dhcp::remote_isc::params::key_name,
  $key_secret      = $::foreman_proxy::plugin::dhcp::remote_isc::params::key_secret,
  $omapi_port      = $::foreman_proxy::plugin::dhcp::remote_isc::params::omapi_port,
) inherits foreman_proxy::plugin::dhcp::remote_isc::params {
  validate_string($dhcp_config, $dhcp_leases)
  validate_integer($omapi_port)

  foreman_proxy::plugin { 'dhcp_remote_isc':
  }
  -> foreman_proxy::settings_file { 'dhcp_remote_isc':
    module        => false,
    template_path => 'foreman_proxy/plugin/dhcp_remote_isc.yml.erb',
  }
}
