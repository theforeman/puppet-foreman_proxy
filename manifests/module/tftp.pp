# @summary The built in TFTP module
#
# @param enabled
#  Whether the module is enabled or disabled.
#
# @param listen_on
#   Where to listen on.
#
# @param tftproot
#   The root directory to use. This is required if the module is enabled.
class foreman_proxy::module::tftp (
  Boolean $enabled = $foreman_proxy::tftp,
  Foreman_proxy::ListenOn $listen_on = $foreman_proxy::tftp_listen_on,
  Optional[Stdlib::Absolutepath] $tftproot = $foreman_proxy::tftp_root,
) {
  if $enabled {
    assert_type(NotUndef, $tftproot)
  }

  foreman_proxy::module { 'tftp':
    enabled   => $enabled,
    listen_on => $listen_on,
  }
}
