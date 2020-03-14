# @summary The built in BMC module
#
# @param enabled
#  Whether the module is enabled or disabled.
#
# @param listen_on
#   Where to listen on.
class foreman_proxy::module::bmc (
  Boolean $enabled = $foreman_proxy::bmc,
  Foreman_proxy::ListenOn $listen_on = $foreman_proxy::bmc_listen_on,
) {
  foreman_proxy::module { 'bmc':
    enabled   => $enabled,
    listen_on => $listen_on,
  }
}
