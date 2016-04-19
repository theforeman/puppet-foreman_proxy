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

  foreman_proxy::tftp::copy_file{$foreman_proxy::tftp_syslinux_filenames:
    target_path => $foreman_proxy::tftp_root,
    require     => Class['tftp::install'];
  }

  if $foreman_proxy::tftp_manage_wget {
    ensure_packages(['wget'], { ensure => $foreman_proxy::ensure_packages_version, })
  }
}
