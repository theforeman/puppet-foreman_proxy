# Set up the foreman service
class foreman_proxy::service {

  service { 'foreman-proxy':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => Class['foreman_proxy::config'],
  }

}
