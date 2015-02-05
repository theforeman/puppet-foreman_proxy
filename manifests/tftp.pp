# Set up the tftp component
class foreman_proxy::tftp {

  class { '::tftp':
    root => $foreman_proxy::tftp_root,
  }

  file{ $foreman_proxy::tftp_dirs:
    ensure  => directory,
    owner   => $foreman_proxy::user,
    mode    => '0644',
    require => Class['foreman_proxy::install', 'tftp::install'],
    recurse => true;
  }

  if $foreman_proxy::tftp_syslinux_files {
  # TODO: remove on the next major version bump
    foreman_proxy::tftp::sync_file{$foreman_proxy::tftp_syslinux_files:
      source_path => $foreman_proxy::tftp_syslinux_root,
      target_path => $foreman_proxy::tftp_root,
      require     => Class['tftp::install'];
    }

    warning('foreman_proxy::tftp_syslinux_files is deprecated in favour of foreman_proxy::tftp_syslinux_filenames and will be removed')
  } else {
    foreman_proxy::tftp::copy_file{$foreman_proxy::tftp_syslinux_filenames:
      target_path => $foreman_proxy::tftp_root,
      require     => Class['tftp::install'];
    }
  }

  ensure_packages(['wget'])

}
