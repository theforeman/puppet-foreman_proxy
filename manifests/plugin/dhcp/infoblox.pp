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
# $wait_after_restart:: Number of seconds to wait after Grid restart
#
# $options:: DHCP options in JSON format: [{"name": "","num": 1,"value": "","vendor_class": ""}]
#
class foreman_proxy::plugin::dhcp::infoblox (
  String $username = undef,
  String $password = undef,
  Enum['host', 'fixedaddress'] $record_type = 'fixedaddress',
  String $dns_view = 'default',
  String $network_view = 'default',
  Integer $wait_after_restart = 10,
  String $options = '[]',
) {
  foreman_proxy::plugin::provider { 'dhcp_infoblox':
  }
}
