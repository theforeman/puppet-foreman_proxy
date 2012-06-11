class foreman_proxy::params {

  include tftp::params

  $use_testing = true

  # variables
  $dir  = '/usr/share/foreman-proxy'
  $user = 'foreman-proxy'
  $log  = '/var/log/foreman-proxy/proxy.log'

  # puppetca settings
  $puppetca          = true
  $autosign_location = '/etc/puppet/autosign.conf'
  $puppetca_cmd      = '/usr/sbin/puppetca'
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
  $dhcp_reverse   = '100.168.192.in-addr.arpa'
  $gateway        = '192.168.100.1'
  $range          = '192.168.100.50 192.168.100.200'
  case $::operatingsystem {
    Debian: {
      $dhcp_vendor = 'isc'
      $dhcp_config = '/etc/dhcp/dhcpd.conf'
      $dhcp_leases = '/var/lib/dhcp/dhcpd.leases'
    }
    Ubuntu: {
      $dhcp_vendor = 'isc'
      $dhcp_config = '/etc/dhcp3/dhcpd.conf'
      $dhcp_leases = '/var/lib/dhcp3/dhcpd.leases'
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
  case $::operatingsystem {
    Debian: {
      $keyfile = '/etc/bind/rndc.key'
    }
    default: {
      $keyfile = '/etc/rndc.key'
    }
  }

}
