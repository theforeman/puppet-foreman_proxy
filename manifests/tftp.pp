# Set up the tftp component
class foreman_proxy::tftp {
  include ::tftp

  file{ $foreman_proxy::tftp_dirs:
    ensure  => directory,
    owner   => $foreman_proxy::user,
    mode    => '0644',
    require => Class['foreman_proxy::install', 'tftp::install'],
    recurse => true;
  }

  foreman_proxy::tftp::sync_file{$foreman_proxy::tftp_syslinux_files:
    source_path => $foreman_proxy::tftp_syslinux_root,
    target_path => $foreman_proxy::tftp_root,
    require     => Class['tftp::install'];
  }

  ensure_packages(['wget'])
}
