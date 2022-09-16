include foreman_proxy
class { 'foreman_proxy::plugin::openscap':
  puppet_module => true,
}
