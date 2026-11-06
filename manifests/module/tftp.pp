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
#
# @param tftp_system_image_root
#   The system image root directory to use. This is required if the module
#   is supposed to download and extract OS image files.
class foreman_proxy::module::tftp (
  Boolean $enabled = $foreman_proxy::tftp,
  Foreman_proxy::ListenOn $listen_on = $foreman_proxy::tftp_listen_on,
  Optional[Stdlib::Absolutepath] $tftproot = $foreman_proxy::tftp_root,
  Optional[Stdlib::Absolutepath] $tftp_system_image_root = $foreman_proxy::tftp_system_image_root,
) {
  if $enabled {
    assert_type(NotUndef, $tftproot)
    assert_type(NotUndef, $tftp_system_image_root)
  }

  foreman_proxy::module { 'tftp':
    enabled   => $enabled,
    feature   => 'TFTP',
    listen_on => $listen_on,
  }
}
