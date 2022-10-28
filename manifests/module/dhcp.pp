# @summary The built in DHCP module
#
# @param enabled
#  Whether the module is enabled or disabled.
#
# @param listen_on
#   Where to listen on.
class foreman_proxy::module::dhcp (
  Boolean $enabled = $foreman_proxy::dhcp,
  Foreman_proxy::ListenOn $listen_on = $foreman_proxy::dhcp_listen_on,
) {
  foreman_proxy::module { 'dhcp':
    enabled   => $enabled,
    feature   => 'DHCP',
    listen_on => $listen_on,
  }
}
