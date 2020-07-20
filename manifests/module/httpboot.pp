# @summary The built in HTTPBoot module
#
# @param enabled
#  Whether the module is enabled or disabled.
#
# @param listen_on
#   Where to listen on.
class foreman_proxy::module::httpboot (
  Boolean $enabled = $foreman_proxy::httpboot,
  Foreman_proxy::ListenOn $listen_on = $foreman_proxy::httpboot_listen_on,
) {
  foreman_proxy::module { 'httpboot':
    enabled   => $enabled,
    feature   => 'HTTPBoot',
    listen_on => $listen_on,
  }
}
