# Set up the tftp component
class foreman_proxy::tftp (
  $tftp_managed = $foreman_proxy::tftp_managed,
) {
  $required_tftp_classes = $tftp_managed ? {
    true    => Class['foreman_proxy::install', 'tftp::install'],
    default => Class['foreman_proxy::install'],
  }

  file{ $foreman_proxy::tftp_dirs:
    ensure  => directory,
    owner   => $foreman_proxy::user,
    mode    => '0644',
    require => $required_tftp_classes,
    recurse => true;
  }

  foreman_proxy::tftp::copy_file{$foreman_proxy::tftp_syslinux_filenames:
    target_path => $foreman_proxy::tftp_root,
    require     => $required_tftp_classes;
  }

  if $foreman_proxy::tftp_manage_wget {
    ensure_packages(['wget'], { ensure => $foreman_proxy::ensure_packages_version, })
  }

  if $tftp_managed {
    class { '::tftp':
      root => $foreman_proxy::tftp_root,
    }
  }

  case $::osfamily {
    'RedHat': {
      $osreleasemajor = regsubst($::operatingsystemrelease, '^(\d+)\..*$', '\1') # workaround for the possibly missing operatingsystemmajrelease
      if versioncmp($osreleasemajor, '6') <= 0 {
        $grub_type = 'redhat_old'
      } else {
        $grub_type = 'redhat'
      }
      # taken from http://pkgs.fedoraproject.org/cgit/rpms/grub2.git/tree/grub2.spec
      $grub_modules = 'all_video boot btrfs cat chain configfile echo efifwsetup efinet ext2 fat font gfxmenu gfxterm gzio halt hfsplus iso9660 jpeg loadenv loopback lvm mdraid09 mdraid1x minicmd normal part_apple part_msdos part_gpt password_pbkdf2 png reboot search search_fs_uuid search_fs_file search_label serial sleep syslinuxcfg test tftp video xfs linux backtrace usb usbserial_common usbserial_pl2303 usbserial_ftdi usbserial_usbdebug linuxefi'
    }
    'Debian': {
      $grub_type = 'debian'
      # taken from https://anonscm.debian.org/cgit/pkg-grub/grub.git/tree/debian/build-efi-images
      $grub_modules = 'all_video boot btrfs cat chain configfile echo efifwsetup efinet ext2 fat font gettext gfxmenu gfxterm gfxterm_background gzio halt hfsplus iso9660 jpeg keystatus loadenv linux lsefi lsefimmap lsefisystab lssal memdisk minicmd normal part_apple part_msdos part_gpt password_pbkdf2 png reboot search search_fs_uuid search_fs_file search_label sleep test true video zfs zfscrypt zfsinfo linuxefi lvm mdraid09 mdraid1x raid5rec raid6rec tftp'
    }
    default: {
      warning("Unable to detect EFI loader for OS family '${::osfamily}'")
      $grub_type = 'unknown'
    }
  }

  $efi_dir = '/usr/lib/grub/x86_64-efi'
  case $::operatingsystem {
    'Fedora': {
      $grub_efi_path = 'fedora'
    }
    'CentOS': {
      $grub_efi_path = 'centos'
    }
    /^(RedHat|Scientific|OracleLinux)$/: {
      $grub_efi_path = 'redhat'
    }
    default: {
      $grub_efi_path = 'unknown'
    }
  }

  case $grub_type {
    'redhat': {
      ensure_packages(['grub2-efi','grub2-efi-modules','grub2-tools','shim'], { ensure => 'installed', })

      exec {'build-grub2-efi-image':
        command => "/usr/bin/grub2-mkimage -O x86_64-efi -d ${efi_dir} -o ${foreman_proxy::tftp_root}/grub2/grubx64.efi -p '' ${grub_modules}",
        creates => "${foreman_proxy::tftp_root}/grub2/grubx64.efi",
        require => [File[$foreman_proxy::tftp_dirs], Package['grub2-tools']],
      }

      foreman_proxy::tftp::copy_file{"/boot/efi/EFI/${grub_efi_path}/shim.efi":
        target_path => "${foreman_proxy::tftp_root}/grub2",
        require     => File[$foreman_proxy::tftp_dirs],
      }
    }
    'redhat_old': {
      ensure_packages(['grub'], { ensure => 'installed', })

      file {"${foreman_proxy::tftp_root}/grub/grubx64.efi":
        ensure  => file,
        source  => "/boot/efi/EFI/${grub_efi_path}/grub.efi",
        require => File[$foreman_proxy::tftp_dirs],
      }

      file {"${foreman_proxy::tftp_root}/grub/shim.efi":
        ensure  => 'link',
        target  => 'grubx64.efi',
        require => File[$foreman_proxy::tftp_dirs],
      }
    }
    'debian': {
      ensure_packages(['grub-common','grub-efi-amd64-bin'], { ensure => 'installed', })

      exec {'build-grub2-efi-image':
        command => "/usr/bin/grub-mkimage -O x86_64-efi -d ${efi_dir} -o ${foreman_proxy::tftp_root}/grub2/grubx64.efi -p '' ${grub_modules}",
        creates => "${foreman_proxy::tftp_root}/grub2/grubx64.efi",
        require => [File[$foreman_proxy::tftp_dirs], Package['grub-common','grub-efi-amd64-bin']],
      }

      file {"${foreman_proxy::tftp_root}/grub2/shim.efi":
        ensure  => 'link',
        target  => 'grubx64.efi',
        require => File[$foreman_proxy::tftp_dirs],
      }
    }
    default: {
      warning('UEFI PXE firmware is not being deployed')
    }
  }
}
