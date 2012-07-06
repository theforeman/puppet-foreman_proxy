class foreman_proxy::proxydhcp {
  $ip_temp   = "ipaddress_${foreman_proxy::dhcp_interface}"
  $ip        = inline_template('<%= scope.lookupvar(ip_temp) %>')

  $net_temp  = "::network_${foreman_proxy::dhcp_interface}"
  $net       = inline_template('<%= scope.lookupvar(net_temp) %>')

  $mask_temp = "::netmask_${foreman_proxy::dhcp_interface}"
  $mask      = inline_template('<%= scope.lookupvar(mask_temp) %>')

  class { 'dhcp':
    dnsdomain    => [
      $::domain,
      $foreman_proxy::dhcp_reverse,
    ],
    nameservers  => [$::ip],
    ntpservers   => $foreman_proxy::ntpservers,
    interfaces   => [$foreman_proxy::dhcp_interface],
    #dnsupdatekey => /etc/bind/keys.d/foreman,
    #require      => Bind::Key[ 'foreman' ],
    pxeserver    => $::ip,
    pxefilename  => 'pxelinux.0',
  }

  dhcp::pool{ $::domain:
    network => $net,
    mask    => $mask,
    range   => $foreman_proxy::range,
    gateway => $foreman_proxy::gateway,
  }
}
