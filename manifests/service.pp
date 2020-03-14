# @summary Set up the foreman service
# @api private
class foreman_proxy::service {

  service { 'foreman-proxy':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => Class['foreman_proxy::config'],
  }

}
