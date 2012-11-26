class foreman_proxy::params {

  include tftp::params
  include puppet::params

  # Packaging
  $use_testing    = false

  # variables
  $dir  = '/usr/share/foreman-proxy'
  $user = 'foreman-proxy'
  $log  = '/var/log/foreman-proxy/proxy.log'

  # puppetca settings
  $puppetca          = true
  $autosign_location = '/etc/puppet/autosign.conf'
  $puppetca_cmd      = $puppet::params::puppetca_cmd
  $puppet_group      = 'puppet'

  # puppetrun settings
  $puppetrun     = true
  $puppetrun_cmd = '/usr/sbin/puppetrun'

  # TFTP settings - requires optional TFTP puppet module
  $tftp           = true
  case $::operatingsystem {
    Debian,Ubuntu: {
      $syslinux_root  = '/usr/lib/syslinux'
      $syslinux_files = ['pxelinux.0','menu.c32','chain.c32']
    }
    default: {
      $syslinux_root  = '/usr/share/syslinux'
      $syslinux_files = ['pxelinux.0','menu.c32','chain.c32']
    }
  }
  $tftproot       = $tftp::params::root
  $tftp_dir       = ["${tftproot}/pxelinux.cfg","${tftproot}/boot"]
  $servername     = $ipaddress_eth0

  # DHCP settings - requires optional DHCP puppet module
  $dhcp           = false
  $dhcp_interface = 'eth0'
  $gateway        = '192.168.100.1'
  $range          = '192.168.100.50 192.168.100.200'
  # This will use the IP of the interface in $dhcp_interface, override
  # if you need to. You can make this a comma-separated string too - it
  # will be split into an array
  $nameservers    = 'default'

  # DHCP server settings
  case $::operatingsystem {
    Debian,Ubuntu: {
      $dhcp_vendor = 'isc'
      $dhcp_config = '/etc/dhcp/dhcpd.conf'
      $dhcp_leases = '/var/lib/dhcp/dhcpd.leases'
    }
    RedHat,CentOS: {
      $dhcp_vendor = 'isc'
      if ($::lsbmajdistrelease == 5) {
        $dhcp_config = '/etc/dhcpd.conf'
      } else {
        $dhcp_config = '/etc/dhcp/dhcpd.conf'
      }
      $dhcp_leases = '/var/lib/dhcpd/dhcpd.leases'
    }
    default: {
      $dhcp_vendor = 'isc'
      $dhcp_config = '/etc/dhcpd.conf'
      $dhcp_leases = '/var/lib/dhcpd/dhcpd.leases'
    }
  }

  # DNS settings - requires optional DNS puppet module
  $dns           = false
  $dns_interface = 'eth0'
  $dns_reverse   = '100.168.192.in-addr.arpa'
  # localhost can resolve to ipv6 which ruby doesn't handle well
  $dns_server    = '127.0.0.1'
  case $::operatingsystem {
    Debian,Ubuntu: {
      $keyfile = '/etc/bind/rndc.key'
      $nsupdate = 'dnsutils'
    }
    default: {
      $keyfile = '/etc/rndc.key'
      $nsupdate = 'bind-utils'
    }
  }

}
