# @summary The built in HDM module
#
# @param enabled
#  Whether the module is enabled or disabled.
#
# @param listen_on
#   Where to listen on.
class foreman_proxy::module::hdm (
  Boolean $enabled = $foreman_proxy::hdm,
  Foreman_proxy::ListenOn $listen_on = $foreman_proxy::hdm_listen_on,
) {
  foreman_proxy::module { 'hdm':
    enabled   => $enabled,
    feature   => 'HDM',
    listen_on => $listen_on,
  }
}
