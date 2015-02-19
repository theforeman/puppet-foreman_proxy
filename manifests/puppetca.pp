# Configure puppet CA component
class foreman_proxy::puppetca {

  file { $foreman_proxy::autosign_location:
    ensure  => file,
    owner   => $foreman_proxy::user,
    group   => $foreman_proxy::puppet_group,
    mode    => '0664',
    require => Class['foreman_proxy::install'],
  }

}
