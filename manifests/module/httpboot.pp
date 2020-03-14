# @summary The built in HTTPBoot module
#
# @param enabled
#  Whether the module is enabled or disabled.
#
# @param listen_on
#   Where to listen on.
class foreman_proxy::module::httpboot (
  Optional[Boolean] $enabled = $foreman_proxy::httpboot,
  Foreman_proxy::ListenOn $listen_on = $foreman_proxy::httpboot_listen_on,
) {
  $real_enabled = pick($enabled, $foreman_proxy::tftp)
  if $real_enabled {
    include foreman_proxy::module::tftp
    unless $foreman_proxy::module::tftp::enabled {
      fail('The HTTPBoot module depends on the TFTP module to be enabled')
    }
  }

  foreman_proxy::module { 'httpboot':
    enabled   => $real_enabled,
    feature   => 'HTTPBoot',
    listen_on => $listen_on,
  }
}
