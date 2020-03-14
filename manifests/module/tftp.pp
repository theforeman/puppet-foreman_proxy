# @summary The built in TFTP module
#
# @param enabled
#  Whether the module is enabled or disabled.
#
# @param listen_on
#   Where to listen on.
class foreman_proxy::module::tftp (
  Boolean $enabled = $foreman_proxy::tftp,
  Foreman_proxy::ListenOn $listen_on = $foreman_proxy::tftp_listen_on,
) {
  foreman_proxy::module { 'tftp':
    enabled   => $enabled,
    listen_on => $listen_on,
  }
}
