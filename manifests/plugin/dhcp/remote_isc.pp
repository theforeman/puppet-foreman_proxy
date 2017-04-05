# = Foreman Proxy Remote ISC DHCP
#
# This class installs Remote ISC DHCPD plugin for Foreman proxy
#
# === Parameters:
#
# $dhcp_config::            DHCP config file path
#
# $dhcp_leases::            DHCP leases file
#
# $key_name::               DHCP key name
#
# $key_secret::             DHCP password
#
# $omapi_port::             DHCP server OMAPI port
#
class foreman_proxy::plugin::dhcp::remote_isc (
  Stdlib::Absolutepath $dhcp_config = $::foreman_proxy::plugin::dhcp::remote_isc::params::dhcp_config,
  Stdlib::Absolutepath $dhcp_leases = $::foreman_proxy::plugin::dhcp::remote_isc::params::dhcp_leases,
  Optional[String] $key_name = $::foreman_proxy::plugin::dhcp::remote_isc::params::key_name,
  Optional[String] $key_secret = $::foreman_proxy::plugin::dhcp::remote_isc::params::key_secret,
  Integer[0, 65535] $omapi_port = $::foreman_proxy::plugin::dhcp::remote_isc::params::omapi_port,
) inherits foreman_proxy::plugin::dhcp::remote_isc::params {
  foreman_proxy::plugin { 'dhcp_remote_isc':
  }
  -> foreman_proxy::settings_file { 'dhcp_remote_isc':
    module        => false,
    template_path => 'foreman_proxy/plugin/dhcp_remote_isc.yml.erb',
  }
}
