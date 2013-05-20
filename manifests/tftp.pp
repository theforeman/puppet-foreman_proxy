class foreman_proxy::tftp {
  include ::tftp

  case $::foreman_proxy::tftp_root {
    undef: {
      require ::tftp::params
      $target_path = $::tftp::params::root
    }
    default : {
      $target_path = $::foreman_proxy::tftp_root
    }
  }

  $tftp_dirs = $::foreman_proxy::tftp_dirs ? {
    undef   => ["${target_path}/pxelinux.cfg", "${target_path}/boot"],
    default => $::foreman_proxy::tftp_dirs,
  }

  file {$tftp_dirs:
    ensure  => directory,
    owner   => $::foreman_proxy::user,
    mode    => '0644',
    require => Class['foreman_proxy::install', 'tftp::install'],
    recurse => true,
  }

  foreman_proxy::tftp::sync_file{$foreman_proxy::tftp_syslinux_files:
    source_path => $::foreman_proxy::tftp_syslinux_root,
    target_path => $target_path,
    require     => Class['tftp::install'],
  }

  package { 'wget':
    ensure => installed,
  }
}
