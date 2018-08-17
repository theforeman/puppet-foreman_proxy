# Parameters for EFI
class foreman_proxy::tftp::netboot::params {
  # taken from https://anonscm.debian.org/cgit/pkg-grub/grub.git/tree/debian/build-efi-images + regexp
  $grub_modules = 'all_video boot btrfs cat chain configfile echo efifwsetup efinet ext2 fat font gettext gfxmenu gfxterm gfxterm_background gzio halt hfsplus iso9660 jpeg keystatus loadenv linux lsefi lsefimmap lsefisystab lssal memdisk minicmd normal part_apple part_msdos part_gpt password_pbkdf2 png reboot search search_fs_uuid search_fs_file search_label sleep test true video zfs zfscrypt zfsinfo linuxefi lvm mdraid09 mdraid1x raid5rec raid6rec tftp regexp'

  case $::osfamily {
    'RedHat': {
      if versioncmp($::operatingsystemmajrelease, '6') <= 0 {
        $grub_installation_type = 'redhat_old'
        $packages = ['grub']
      } elsif versioncmp($::operatingsystemrelease, '7.4') == 0 and $::operatingsystem != 'Fedora' {
        # RHEL 7.4 renamed packages and introduced a regression in the MAC
        # loading of configs, it was fixed in 7.5
        # https://bugzilla.redhat.com/show_bug.cgi?id=1483740
        $grub_installation_type = 'redhat_exec'
        $packages = ['grub2-efi-x64','grub2-efi-x64-modules','grub2-tools','shim-x64']
      } elsif versioncmp($::operatingsystemrelease, '7.4') > 0 and $::operatingsystem != 'Fedora' {
        $grub_installation_type = 'redhat'
        $packages = ['grub2-efi-x64','grub2-efi-x64-modules','grub2-tools','shim-x64']
      } elsif versioncmp($::operatingsystemrelease, '27') >= 0 and $::operatingsystem == 'Fedora' {
        # Fedora 27 started using RHEL7.4 naming scheme for grub2* packages 
        $grub_installation_type = 'redhat'
        $packages = ['grub2-efi-x64','grub2-efi-x64-modules','grub2-tools','shim-x64']
      } else {
        $grub_installation_type = 'redhat'
        $packages = ['grub2-efi','grub2-efi-modules','grub2-tools','shim']
      }
    }
    'Debian': {
      $grub_installation_type = 'debian'
      $packages = ['grub-common','grub-efi-amd64-bin']
    }
    default: {
      warning("Unable to detect EFI loader for OS family '${::osfamily}'")
      $grub_installation_type = 'none'
      $packages = []
    }
  }
}
