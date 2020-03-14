# @summary The built in Realm module
#
# @param enabled
#  Whether the module is enabled or disabled.
#
# @param listen_on
#   Where to listen on.
class foreman_proxy::module::realm (
  Boolean $enabled = $foreman_proxy::realm,
  Foreman_proxy::ListenOn $listen_on = $foreman_proxy::realm_listen_on,
) {
  foreman_proxy::module { 'realm':
    enabled   => $enabled,
    feature   => 'Realm',
    listen_on => $listen_on,
  }
}
