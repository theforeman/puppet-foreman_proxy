class foreman_proxy::tftp {
  include ::tftp

  file{ $foreman_proxy::tftp_dir:
    ensure  => directory,
    owner   => $foreman_proxy::user,
    mode    => '0644',
    require => Class['foreman_proxy::install', 'tftp::install'],
    recurse => true;
  }

  foreman_proxy::tftp::sync_file{$foreman_proxy::syslinux_files:
    source_path => $foreman_proxy::syslinux_root,
    target_path => $foreman_proxy::tftproot,
    require     => Class['tftp::install'];
  }

  package { 'wget':
    ensure => installed,
  }
}
