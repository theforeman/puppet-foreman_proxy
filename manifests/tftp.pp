# Set up the tftp component
class foreman_proxy::tftp (
  $user = $::foreman_proxy::user,
  $root = $::foreman_proxy::tftp_root,
  $directories = $::foreman_proxy::tftp_dirs,
  $syslinux_filenames = $::foreman_proxy::tftp_syslinux_filenames,
  $manage_wget = $::foreman_proxy::tftp_manage_wget,
  $wget_version = $::foreman_proxy::ensure_packages_version,
) {
  class { '::tftp':
    root => $root,
  }

  file { $directories:
    ensure  => directory,
    owner   => $user,
    mode    => '0644',
    require => Class['foreman_proxy::install', 'tftp::install'],
    recurse => true,
  }

  file { "${root}/grub2/grub.cfg":
    ensure  => file,
    owner   => $user,
    mode    => '0644',
    content => file('foreman_proxy/grub.cfg'),
  }

  $syslinux_filenames.each |$source_file| {
    $filename = basename($source_file)
    file {"${root}/${filename}":
      ensure  => file,
      source  => $source_file,
      require => Class['foreman_proxy::install', 'tftp::install'],
    }
  }

  if $manage_wget {
    ensure_packages(['wget'], { ensure => $wget_version, })
  }

  case $::osfamily {
    'RedHat': {
      if versioncmp($::operatingsystemmajrelease, '6') <= 0 {
        $grub_type = 'redhat_old'
        $grub_packages = ['grub']
      } else {
        $grub_type = 'redhat'
        $grub_packages = ['grub2-efi','grub2-efi-modules','grub2-tools','shim']
      }
    }
    'Debian': {
      $grub_type = 'debian'
      $grub_packages = ['grub-common','grub-efi-amd64-bin']
      # taken from https://anonscm.debian.org/cgit/pkg-grub/grub.git/tree/debian/build-efi-images + regexp
      $grub_modules = 'all_video boot btrfs cat chain configfile echo efifwsetup efinet ext2 fat font gettext gfxmenu gfxterm gfxterm_background gzio halt hfsplus iso9660 jpeg keystatus loadenv linux lsefi lsefimmap lsefisystab lssal memdisk minicmd normal part_apple part_msdos part_gpt password_pbkdf2 png reboot search search_fs_uuid search_fs_file search_label sleep test true video zfs zfscrypt zfsinfo linuxefi lvm mdraid09 mdraid1x raid5rec raid6rec tftp regexp'
    }
    default: {
      warning("Unable to detect EFI loader for OS family '${::osfamily}'")
      $grub_type = 'unknown'
      $grub_packages = []
    }
  }

  $efi_dir = '/usr/lib/grub/x86_64-efi'
  case $::operatingsystem {
    'Fedora': {
      $grub_efi_path = 'fedora'
    }
    'CentOS': {
      if versioncmp($::operatingsystemmajrelease, '6') <= 0 {
        $grub_efi_path = 'redhat'
      } else {
        $grub_efi_path = 'centos'
      }
    }
    /^(RedHat|Scientific|OracleLinux)$/: {
      $grub_efi_path = 'redhat'
    }
    default: {
      $grub_efi_path = 'unknown'
    }
  }

  ensure_packages($grub_packages, { ensure => 'installed', })

  case $grub_type {
    'redhat': {
      file { "${root}/grub2/grubx64.efi":
        ensure => file,
        source => "/boot/efi/EFI/${grub_efi_path}/grubx64.efi",
      }

      file { "${root}/grub2/shim.efi":
        ensure => file,
        source => "/boot/efi/EFI/${grub_efi_path}/shim.efi",
      }
    }
    'redhat_old': {
      file {"${root}/grub/grubx64.efi":
        ensure => file,
        owner  => 'root',
        mode   => '0644',
        source => "/boot/efi/EFI/${grub_efi_path}/grub.efi",
      }

      file {"${root}/grub/shim.efi":
        ensure => 'link',
        target => 'grubx64.efi',
      }
    }
    'debian': {
      exec {'build-grub2-efi-image':
        command => "/usr/bin/grub-mkimage -O x86_64-efi -d ${efi_dir} -o ${root}/grub2/grubx64.efi -p '' ${grub_modules}",
        unless  => "/bin/grep -q regexp '${root}/grub2/grubx64.efi'",
        require => [File[$directories], Package[$grub_packages]],
      }
      -> file {"${root}/grub2/grubx64.efi":
        mode  => '0644',
        owner => 'root',
      }

      file {"${root}/grub2/shim.efi":
        ensure => 'link',
        target => 'grubx64.efi',
      }
    }
    default: {
      warning('UEFI PXE firmware is not being deployed')
    }
  }
}
