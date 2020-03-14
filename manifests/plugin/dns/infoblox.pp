# = Foreman Proxy Infoblox DNS plugin
#
# This class installs the Infoblox DNS plugin for Foreman proxy
#
# === Parameters:
#
# $dns_server:: The address of the Infoblox server
#
# $username::   The username of the Infoblox user
#
# $password::   The password of the Infoblox user
#
# $dns_view::   The Infoblox DNS View
#
class foreman_proxy::plugin::dns::infoblox (
  Stdlib::Host $dns_server = undef,
  String $username = undef,
  String $password = undef,
  String $dns_view = 'default',
) {
  foreman_proxy::plugin::provider { 'dns_infoblox':
  }
}
