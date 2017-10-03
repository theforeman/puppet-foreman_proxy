# Netboot support for TFTP. Installs the files so other systems can netboot.
class foreman_proxy::tftp::netboot (
  Array[String] $packages = $::foreman_proxy::tftp::netboot::params::packages,
  Enum['redhat_exec', 'redhat', 'redhat_old', 'debian', 'none'] $grub_installation_type = $::foreman_proxy::tftp::netboot::params::grub_installation_type,
  String $grub_modules = $::foreman_proxy::tftp::netboot::params::grub_modules,
  Stdlib::Absolutepath $root = $::foreman_proxy::tftp::root,
) inherits foreman_proxy::tftp::netboot::params {
  ensure_packages($packages, { ensure => 'present', })

  case $grub_installation_type {
    'redhat_exec': {
      $efi_lib_dir = '/usr/lib/grub/x86_64-efi'
      $grub_efi_path = $::operatingsystem ? {
        /Fedora|CentOS/ => downcase($::operatingsystem),
        default         => 'redhat',
      }

      exec { 'build-grub2-efi-image':
        command => "/usr/bin/grub2-mkimage -O x86_64-efi -d ${efi_lib_dir} -o ${root}/grub2/grubx64.efi -p '' ${grub_modules}",
        unless  => "/bin/grep -q regexp '${root}/grub2/grubx64.efi'",
        require => Package[$packages],
      }
      -> file { "${root}/grub2/grubx64.efi":
        mode  => '0644',
        owner => 'root',
      }

      file { "${root}/grub2/shim.efi":
        ensure => file,
        source => "/boot/efi/EFI/${grub_efi_path}/shim.efi",
      }
    }
    'redhat': {
      $grub_efi_path = $::operatingsystem ? {
        /Fedora|CentOS/ => downcase($::operatingsystem),
        default         => 'redhat',
      }

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
        source => '/boot/efi/EFI/redhat/grub.efi',
      }

      file {"${root}/grub/shim.efi":
        ensure => 'link',
        target => 'grubx64.efi',
      }
    }
    'debian': {
      $efi_lib_dir = '/usr/lib/grub/x86_64-efi'
      exec { 'build-grub2-efi-image':
        command => "/usr/bin/grub-mkimage -O x86_64-efi -d ${efi_lib_dir} -o ${root}/grub2/grubx64.efi -p '' ${grub_modules}",
        unless  => "/bin/grep -q regexp '${root}/grub2/grubx64.efi'",
        require => Package[$packages],
      }
      -> file { "${root}/grub2/grubx64.efi":
        mode  => '0644',
        owner => 'root',
      }

      file {"${root}/grub2/shim.efi":
        ensure => 'link',
        target => 'grubx64.efi',
      }
    }
    'none': {
    }
    default: {
      fail("Unexpected installation type ${grub_installation_type}")
    }
  }
}
