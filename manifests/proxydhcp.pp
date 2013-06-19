# Configure the DHCP component
class foreman_proxy::proxydhcp {
  $ip   = inline_template("<%= scope.lookupvar('::ipaddress_${foreman_proxy::dhcp_interface}') %>")
  $net  = inline_template("<%= scope.lookupvar('::network_${foreman_proxy::dhcp_interface}') %>")
  $mask = inline_template("<%= scope.lookupvar('::netmask_${foreman_proxy::dhcp_interface}') %>")

  if $foreman_proxy::dhcp_nameservers == 'default' {
    $nameservers = [$ip]
  } else {
    $nameservers = split($foreman_proxy::dhcp_nameservers,',')
  }

  class { 'dhcp':
    dnsdomain    => [$::domain],
    nameservers  => $nameservers,
    interfaces   => [$foreman_proxy::dhcp_interface],
    #dnsupdatekey => /etc/bind/keys.d/foreman,
    #require      => Bind::Key[ 'foreman' ],
    pxeserver    => $ip,
    pxefilename  => 'pxelinux.0',
  }

  dhcp::pool{ $::domain:
    network => $net,
    mask    => $mask,
    range   => $foreman_proxy::dhcp_range,
    gateway => $foreman_proxy::dhcp_gateway,
  }
}
