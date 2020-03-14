# @summary The built in Puppet CA module
#
# @param enabled
#  Whether the module is enabled or disabled.
#
# @param listen_on
#   Where to listen on.
class foreman_proxy::module::puppetca (
  Boolean $enabled = $foreman_proxy::puppetca,
  Foreman_proxy::ListenOn $listen_on = $foreman_proxy::puppetca_listen_on,
) {
  foreman_proxy::module { 'puppetca':
    enabled   => $enabled,
    feature   => 'Puppet CA',
    listen_on => $listen_on,
  }
}
