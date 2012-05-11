class foreman_proxy::proxydhcp {
  include foreman_proxy::params

  $ip_temp   = "ipaddress_${foreman_proxy::params::dhcp_interface}"
  $ip        = inline_template("<%= scope.lookupvar(ip_temp) %>")

  $net_temp  = "::network_${foreman_proxy::params::dhcp_interface}"
  $net       = inline_template("<%= scope.lookupvar(net_temp) %>")

  $mask_temp = "::netmask_${foreman_proxy::params::dhcp_interface}"
  $mask      = inline_template("<%= scope.lookupvar(mask_temp) %>")

  class { 'dhcp':
    dnsdomain    => [
      "${::domain}",
      "${foreman_proxy::params::dhcp_reverse}",
    ],
    nameservers  => ["${ip}"],
    ntpservers   => ['us.pool.ntp.org'],
    interfaces   => ["${foreman_proxy::params::dhcp_interface}"],
    #dnsupdatekey => "/etc/bind/keys.d/foreman",
    #require      => Bind::Key[ 'foreman' ],
    pxeserver    => "${ip}",
    pxefilename  => 'pxelinux.0',
  }

  dhcp::pool{ "${::domain}":
    network => "${net}",
    mask    => "${mask}",
    range   => "${foreman_proxy::params::range}",
    gateway => "${foreman_proxy::params::gateway}",
  }


}
