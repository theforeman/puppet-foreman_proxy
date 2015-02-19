# Configure the DHCP component
class foreman_proxy::proxydhcp {
  # puppet fact names are converted from ethX.X and ethX:X to ethX_X
  # so for alias and vlan interfaces we have to modify the name accordingly
  $interface_fact_name = regsubst($foreman_proxy::dhcp_interface, '[.:]', '_')
  $ip   = inline_template("<%= scope.lookupvar('::ipaddress_${interface_fact_name}') %>")
  if ! is_ip_address($ip) {
    fail("Could not get the ip address from fact ipaddress_${interface_fact_name}")
  }

  $net  = inline_template("<%= scope.lookupvar('::network_${interface_fact_name}') %>")
  if ! is_ip_address($net) {
    fail("Could not get the network address from fact network_${interface_fact_name}")
  }

  $mask = inline_template("<%= scope.lookupvar('::netmask_${interface_fact_name}') %>")
  if ! is_ip_address($mask) {
    fail("Could not get the network mask from fact netmask_${interface_fact_name}")
  }

  if $foreman_proxy::dhcp_nameservers == 'default' {
    $nameservers = [$ip]
  } else {
    $nameservers = split($foreman_proxy::dhcp_nameservers,',')
  }

  class { '::dhcp':
    dnsdomain   => $foreman_proxy::dhcp_option_domain,
    nameservers => $nameservers,
    interfaces  => [$foreman_proxy::dhcp_interface],
    pxeserver   => $ip,
    pxefilename => 'pxelinux.0',
  }

  ::dhcp::pool{ $::domain:
    network => $net,
    mask    => $mask,
    range   => $foreman_proxy::dhcp_range,
    gateway => $foreman_proxy::dhcp_gateway,
  }
}
