# Set up the tftp component
class foreman_proxy::tftp (
  $user = $::foreman_proxy::user,
  $root = $::foreman_proxy::tftp_root,
  $directories = $::foreman_proxy::tftp_dirs,
  $syslinux_filenames = $::foreman_proxy::tftp_syslinux_filenames,
  $manage_wget = $::foreman_proxy::tftp_manage_wget,
  $wget_version = $::foreman_proxy::ensure_packages_version,
  $tftp_replace_grub2_cfg = $::foreman_proxy::tftp_replace_grub2_cfg,
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
    replace => $tftp_replace_grub2_cfg,
  }

  $syslinux_filenames.each |$source_file| {
    $filename = basename($source_file)
    file {"${root}/${filename}":
      ensure  => file,
      owner   => $user,
      mode    => '0644',
      source  => $source_file,
      require => Class['foreman_proxy::install', 'tftp::install'],
    }
  }

  if $manage_wget {
    ensure_packages(['wget'], { ensure => $wget_version, })
  }

  contain ::foreman_proxy::tftp::netboot

  File[$directories] -> Class['foreman_proxy::tftp::netboot']
}
