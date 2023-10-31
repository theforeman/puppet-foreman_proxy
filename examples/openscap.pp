include foreman_proxy
class { 'foreman_proxy::plugin::openscap':
  ansible_module => true,
  puppet_module  => true,
}
