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
# $use_ranges::  Use pre-definded ranges in networks to find available IP's
#
class foreman_proxy::plugin::dhcp::infoblox (
  String $username = undef,
  String $password = undef,
  Enum['host', 'fixedaddress'] $record_type = 'fixedaddress',
  Boolean $use_ranges = false,
) {
  foreman_proxy::plugin { 'dhcp_infoblox':
  }
  -> foreman_proxy::settings_file { 'dhcp_infoblox':
    module        => false,
    template_path => 'foreman_proxy/plugin/dhcp_infoblox.yml.erb',
  }
}
