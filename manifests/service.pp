# @summary Set up the foreman service
# @api private
class foreman_proxy::service {
  if $foreman_proxy::manage_service {
    service { 'foreman-proxy':
      ensure => running,
      enable => true,
    }
  }
}
