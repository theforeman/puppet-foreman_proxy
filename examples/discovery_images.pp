class { 'foreman_proxy':
  tftp => true,
}
class { 'foreman_proxy::plugin::discovery':
  install_images => true,
}
