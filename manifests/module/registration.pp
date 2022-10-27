# @summary The built in Registration module
#
# @param enabled
#  Whether the module is enabled or disabled.
#
# @param listen_on
#   Where to listen on.
#
# @param registration_url
#   URL that hosts will connect to when registering, defaults to the proxy URL.
#
class foreman_proxy::module::registration (
  Boolean $enabled = $foreman_proxy::registration,
  Foreman_proxy::ListenOn $listen_on = $foreman_proxy::registration_listen_on,
  Optional[Stdlib::HTTPUrl] $registration_url = $foreman_proxy::registration_url,
) {
  foreman_proxy::module { 'registration':
    enabled   => $enabled,
    feature   => 'Registration',
    listen_on => $listen_on,
  }
}
