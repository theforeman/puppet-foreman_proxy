# = Foreman Proxy Infoblox DHCP
#
# This class installs the Infoblox DHCP plugin for Foreman proxy
#
# === Parameters:
#
# $username::             The username of the Infoblox user
#
# $password::             The password of the Infoblox user
#
# $record_type::          Record type to manage
#
# $dns_view::             The DNS view to use
#
# $network_view::         The network view to use
#
# $used_ips_search_type:: The search type for used ips
#
class foreman_proxy::plugin::dhcp::infoblox (
  String $username = undef,
  String $password = undef,
  Enum['host', 'fixedaddress'] $record_type = 'fixedaddress',
  String $dns_view = 'default',
  String $network_view = 'default',
  Enum['record_type', 'used'] $used_ips_search_type = 'record_type',
) {
  foreman_proxy::plugin::provider { 'dhcp_infoblox':
  }
}
