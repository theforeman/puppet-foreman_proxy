# @summary The built in WOL module
#
# @param enabled
#  Whether the module is enabled or disabled.
#
# @param listen_on
#   Where to listen on.
class foreman_proxy::module::wol (
  Boolean $enabled = $foreman_proxy::wol,
  Foreman_proxy::ListenOn $listen_on = $foreman_proxy::wol_listen_on,
) {
  foreman_proxy::module { 'wol':
    enabled   => $enabled,
    feature   => 'WOL',
    listen_on => $listen_on,
  }
}
