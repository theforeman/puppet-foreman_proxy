# @summary Parameters for EFI
# @api private
class foreman_proxy::tftp::netboot::params {
  # taken from https://anonscm.debian.org/cgit/pkg-grub/grub.git/tree/debian/build-efi-images + regexp
  $grub_modules = 'all_video boot btrfs cat chain configfile echo efifwsetup efinet ext2 fat font gettext gfxmenu gfxterm gfxterm_background gzio halt hfsplus iso9660 jpeg keystatus loadenv linux lsefi lsefimmap lsefisystab lssal memdisk minicmd normal part_apple part_msdos part_gpt password_pbkdf2 png reboot search search_fs_uuid search_fs_file search_label sleep test true video zfs zfscrypt zfsinfo linuxefi lvm mdraid09 mdraid1x raid5rec raid6rec tftp regexp'

  case $facts['os']['family'] {
    'RedHat': {
      $grub_installation_type = 'redhat'
      $packages = ['grub2-efi-x64','grub2-efi-x64-modules','grub2-tools','shim-x64']
    }
    'Debian': {
      $grub_installation_type = 'debian'
      $packages = ['grub-common','grub-efi-amd64-bin']
    }
    default: {
      warning("Unable to detect EFI loader for OS family '${facts['os']['family']}'")
      $grub_installation_type = 'none'
      $packages = []
    }
  }
}
