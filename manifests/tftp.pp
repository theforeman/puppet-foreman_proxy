# @summary Set up the tftp service
# @api private
class foreman_proxy::tftp (
  String[1] $user = $foreman_proxy::user,
  Optional[Stdlib::Absolutepath] $root = $foreman_proxy::tftp_root,
  Optional[Array[Stdlib::Absolutepath]] $directories = $foreman_proxy::tftp_dirs,
  Array[Stdlib::Absolutepath] $syslinux_filenames = $foreman_proxy::params::tftp_syslinux_filenames,
  Boolean $manage_wget = $foreman_proxy::tftp_manage_wget,
  String[1] $wget_version = $foreman_proxy::ensure_packages_version,
  Boolean $tftp_replace_grub2_cfg = $foreman_proxy::tftp_replace_grub2_cfg,
) {
  class { 'tftp':
    root => $root,
  }

  $dirs = pick($directories, prefix([
        'pxelinux.cfg',
        'grub',
        'grub2',
        'boot',
        'ztp.cfg',
        'poap.cfg',
        'host-config',
        'bootloader-universe',
        'bootloader-universe/pxegrub2',
  ], "${tftp::root}/"))

  file { $dirs:
    ensure    => directory,
    owner     => $user,
    max_files => -1,
    mode      => '0644',
    require   => Class['foreman_proxy::install', 'tftp::install'],
    recurse   => true,
  }

  file { "${tftp::root}/grub2/grub.cfg":
    ensure  => file,
    owner   => $user,
    mode    => '0644',
    content => file('foreman_proxy/grub.cfg'),
    replace => $tftp_replace_grub2_cfg,
  }

  $syslinux_filenames.each |$source_file| {
    $filename = basename($source_file)
    file { "${tftp::root}/${filename}":
      ensure  => file,
      owner   => $user,
      mode    => '0644',
      source  => $source_file,
      require => Class['foreman_proxy::install', 'tftp::install'],
    }
  }

  if $manage_wget {
    stdlib::ensure_packages(['wget'], { ensure => $wget_version, })
  }

  class { 'foreman_proxy::tftp::netboot':
    root    => $tftp::root,
    require => File[$directories],
  }
  contain foreman_proxy::tftp::netboot
}
