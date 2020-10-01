# @summary The built in Registration module
#
# @param enabled
#  Whether the module is enabled or disabled.
#
# @param listen_on
#   Where to listen on.
class foreman_proxy::module::registration (
  Boolean $enabled = $foreman_proxy::registration,
  Foreman_proxy::ListenOn $listen_on = $foreman_proxy::registration_listen_on,
) {
  foreman_proxy::module { 'registration':
    enabled   => $enabled,
    feature   => 'Registration',
    listen_on => $listen_on,
  }
}
