# @summary Netboot support for TFTP. Installs the files so other systems can netboot.
#
# @param packages
#   The packages to install
#
# @param grub_installation_type
#   The method to configure grub
#
# @param grub_modules
#   The grub modules to enable
#
# @param root
#   The root directory to use for grub
#
class foreman_proxy::tftp::netboot (
  Stdlib::Absolutepath $root,
  Array[String] $packages = $foreman_proxy::tftp::netboot::params::packages,
  Enum['redhat', 'debian', 'none'] $grub_installation_type = $foreman_proxy::tftp::netboot::params::grub_installation_type,
  String $grub_modules = $foreman_proxy::tftp::netboot::params::grub_modules,
) inherits foreman_proxy::tftp::netboot::params {
  ensure_packages($packages, { ensure => 'present', })

  # The symlink from grub2/boot to boot is needed for UEFI HTTP boot
  file {"${root}/grub2/boot":
    ensure => 'link',
    target => '../boot',
  }

  case $grub_installation_type {
    'redhat': {
      $grub_efi_path = $facts['os']['name'] ? {
        /Fedora|CentOS/ => downcase($facts['os']['name']),
        default         => 'redhat',
      }

      file { "${root}/grub2/grubx64.efi":
        ensure => file,
        source => "/boot/efi/EFI/${grub_efi_path}/grubx64.efi",
      }

      file { "${root}/grub2/shimx64.efi":
        ensure => file,
        source => "/boot/efi/EFI/${grub_efi_path}/shimx64.efi",
        mode   => '0644',
        owner  => 'root',
      }

      file { "${root}/grub2/shim.efi":
        ensure => 'link',
        target => 'shimx64.efi',
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

      file { "${root}/grub2/shim.efi":
        ensure => 'link',
        target => 'grubx64.efi',
      }

      file { "${root}/grub2/shimx64.efi":
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
