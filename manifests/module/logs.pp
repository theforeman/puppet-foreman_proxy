# @summary The built in Logs module
#
# @param enabled
#  Whether the module is enabled or disabled.
#
# @param listen_on
#   Where to listen on.
class foreman_proxy::module::logs (
  Boolean $enabled = $foreman_proxy::logs,
  Foreman_proxy::ListenOn $listen_on = $foreman_proxy::logs_listen_on,
) {
  foreman_proxy::module { 'logs':
    enabled   => $enabled,
    feature   => 'Logs',
    listen_on => $listen_on,
  }
}
