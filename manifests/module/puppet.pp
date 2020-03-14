# @summary The built in Puppet module
#
# @param enabled
#  Whether the module is enabled or disabled.
#
# @param listen_on
#   Where to listen on.
class foreman_proxy::module::puppet (
  Boolean $enabled = $foreman_proxy::puppet,
  Foreman_proxy::ListenOn $listen_on = $foreman_proxy::puppet_listen_on,
) {
  foreman_proxy::module { 'puppet':
    enabled   => $enabled,
    feature   => 'Puppet',
    listen_on => $listen_on,
  }
}
