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
  Stdlib::Absolutepath $dhcp_config = '/etc/dhcp/dhcpd.conf',
  Stdlib::Absolutepath $dhcp_leases = '/var/lib/dhcpd/dhcpd.leases',
  Optional[String] $key_name = undef,
  Optional[String] $key_secret = undef,
  Stdlib::Port $omapi_port = 7911,
) {
  foreman_proxy::plugin { 'dhcp_remote_isc':
  }
  -> foreman_proxy::settings_file { 'dhcp_remote_isc':
    module        => false,
    template_path => 'foreman_proxy/plugin/dhcp_remote_isc.yml.erb',
  }
}
