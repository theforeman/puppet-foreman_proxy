# @summary The built in DNS module
#
# @param enabled
#  Whether the module is enabled or disabled.
#
# @param listen_on
#   Where to listen on.
class foreman_proxy::module::dns (
  Boolean $enabled = $foreman_proxy::dns,
  Foreman_proxy::ListenOn $listen_on = $foreman_proxy::dns_listen_on,
) {
  foreman_proxy::module { 'dns':
    enabled   => $enabled,
    listen_on => $listen_on,
  }
}
