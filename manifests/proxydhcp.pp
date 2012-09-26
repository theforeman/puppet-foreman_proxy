class foreman_proxy::proxydhcp {
  class { 'dhcp':
    dnsdomain    => [
      $::domain,
      $foreman_proxy::dhcp_reverse,
    ],
    nameservers  => $foreman_proxy::dhcp_nameservers,
    interfaces   => [$foreman_proxy::dhcp_interface],
    #dnsupdatekey => /etc/bind/keys.d/foreman,
    #require      => Bind::Key[ 'foreman' ],
    pxeserver    => $foreman_proxy::ip,
    pxefilename  => 'pxelinux.0',
  }

  dhcp::pool{ $::domain:
    network => $foreman_proxy::net,
    mask    => $foreman_proxy::mask,
    range   => $foreman_proxy::range,
    gateway => $foreman_proxy::gateway,
  }
}
