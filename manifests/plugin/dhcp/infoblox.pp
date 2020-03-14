# = Foreman Proxy Infoblox DHCP
#
# This class installs the Infoblox DHCP plugin for Foreman proxy
#
# === Parameters:
#
# $username::    The username of the Infoblox user
#
# $password::    The password of the Infoblox user
#
# $record_type:: Record type to manage
#
# $dns_view::    The DNS view to use
#
# $network_view:: The network view to use
#
class foreman_proxy::plugin::dhcp::infoblox (
  String $username = undef,
  String $password = undef,
  Enum['host', 'fixedaddress'] $record_type = 'fixedaddress',
  String $dns_view = 'default',
  String $network_view = 'default',
) {
  foreman_proxy::plugin::provider { 'dhcp_infoblox':
  }
}
