# @summary The built in Templates module
#
# @param enabled
#  Whether the module is enabled or disabled.
#
# @param listen_on
#   Where to listen on.
class foreman_proxy::module::templates (
  Boolean $enabled = $foreman_proxy::templates,
  Foreman_proxy::ListenOn $listen_on = $foreman_proxy::templates_listen_on,
) {
  foreman_proxy::module { 'templates':
    enabled   => $enabled,
    feature   => 'Templates',
    listen_on => $listen_on,
  }
}
