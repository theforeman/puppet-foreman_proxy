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
# @param tftp_bootloader_universe
#   Directory for OS specific Network Bootstrap Programs for "Grub2 UEFI" PXE loaders.
class foreman_proxy::module::tftp (
  Boolean $enabled = $foreman_proxy::tftp,
  Foreman_proxy::ListenOn $listen_on = $foreman_proxy::tftp_listen_on,
  Optional[Stdlib::Absolutepath] $tftproot = $foreman_proxy::tftp_root,
  Optional[Stdlib::Absolutepath] $tftp_bootloader_universe = $foreman_proxy::tftp_bootloader_universe,
) {
  if $enabled {
    assert_type(NotUndef, $tftproot)
  }

  foreman_proxy::module { 'tftp':
    enabled   => $enabled,
    feature   => 'TFTP',
    listen_on => $listen_on,
  }
}
