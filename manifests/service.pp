# @summary Set up the foreman service
# @api private
class foreman_proxy::service {
  service { 'foreman-proxy':
    ensure => running,
    enable => true,
  }
}
