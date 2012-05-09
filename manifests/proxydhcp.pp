class foreman_proxy::proxydhcp {
  include foreman_proxy::params

  class { 'dhcp':
    dnsdomain    => [
      "${::domain}",
      "100.168.192.in-addr.arpa",
    ],
    nameservers  => ["${::ipaddress}"],
    ntpservers   => ['us.pool.ntp.org'],
    interfaces   => ['eth0'],
    #dnsupdatekey => "/etc/bind/keys.d/foreman",
    #require      => Bind::Key[ 'foreman' ],
    pxeserver    => "${::ipaddress}",
    pxefilename  => 'pxelinux.0',
    dhcp_monitor => false,
  }

  dhcp::pool{ "${::domain}":
    network => "${::network_eth0}",
    mask    => "${::netmask_eth0}",
    range   => "${foreman_proxy::params::range}",
    gateway => "${foreman_proxy::params::gateway}",
  }


}
