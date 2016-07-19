# Set up the tftp component
class foreman_proxy::tftp (
  $tftp_managed = $foreman_proxy::tftp_managed,
) {

  if $tftp_managed {

    $required_tftp_classes = $tftp_managed ? {
      true    => Class['foreman_proxy::install', 'tftp::install'],
      default => Class['foreman_proxy::install'],
    }
    
    class { '::tftp':
      root => $foreman_proxy::tftp_root,
    }

    file { $foreman_proxy::tftp_dirs:
      ensure  => directory,
      owner   => $foreman_proxy::user,
      mode    => '0644',
      require => $required_tftp_classes,
      recurse => true;
    }

    foreman_proxy::tftp::copy_file { $foreman_proxy::tftp_syslinux_filenames:
      target_path => $foreman_proxy::tftp_root,
      require     => $required_tftp_classes;
    }
  
  }

  if $foreman_proxy::tftp_manage_wget {
    ensure_packages(['wget'], { ensure => $foreman_proxy::ensure_packages_version, })
  }

}
