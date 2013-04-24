class foreman_proxy::params {

  include puppet::params

  # Packaging
  $repo = stable
  # if set to true, no repo will be added by this module, letting you to
  # set it to some custom location.
  $custom_repo = false

  # variables
  $port = "8443"
  $dir  = '/usr/share/foreman-proxy'
  $user = 'foreman-proxy'
  $log  = '/var/log/foreman-proxy/proxy.log'

  $puppet_home = '/var/lib/puppet'

  # Enable SSL, ensure proxy is added with "https://" protocol if true
  $ssl = true
  # If CA is specified, remote Foreman host will be verified
  $default_ssl_ca = "${puppet_home}/ssl/certs/ca.pem"
  # Used to communicate to Foreman
  $default_ssl_cert = "${puppet_home}/ssl/certs/${fqdn}.pem"
  $default_ssl_key = "${puppet_home}/ssl/private_keys/${fqdn}.pem"

  # Only hosts listed will be permitted, empty array to disable authorization
  $trusted_hosts = []

  # Whether to manage File['/etc/sudoers.d'] or not.  When reusing this module, this may be
  # disabled to let a dedicated sudo module manage it instead.
  $manage_sudoersd = true

  # Should we assume a sudoers.d dir exists ( 'false' will use augeas instead )
  case $::operatingsystem {
    redhat,centos,Scientific: {
      if $::operatingsystemrelease >= 6 {
        $use_sudoersd = true
      } else {
        $use_sudoersd = false
      }
    }
    default: {
      $use_sudoersd = true
    }
  }

  # puppetca settings
  $puppetca          = true
  $autosign_location = '/etc/puppet/autosign.conf'
  $puppetca_cmd      = $puppet::params::puppetca_cmd
  $puppet_group      = 'puppet'

  # puppetrun settings
  $puppetrun     = true
  $puppetrun_cmd = $puppet::params::puppetrun_cmd

  # TFTP settings - requires optional TFTP puppet module
  $tftp           = true
  case $::operatingsystem {
    Debian,Ubuntu: {
      $tftp_syslinux_root = '/usr/lib/syslinux'
    }
    default: {
      $tftp_syslinux_root = '/usr/share/syslinux'
    }
  }
  $tftp_syslinux_files = ['pxelinux.0','menu.c32','chain.c32']
  # tftp_root and tftp_dirs are initialized in foreman_proxy::tftp.
  $tftp_root           = undef
  $tftp_dirs           = undef
  $tftp_servername     = $ipaddress_eth0

  # DHCP settings - requires optional DHCP puppet module
  $dhcp             = false
  $dhcp_managed     = true
  $dhcp_interface   = 'eth0'
  $dhcp_gateway     = '192.168.100.1'
  $dhcp_range       = '192.168.100.50 192.168.100.200'
  # This will use the IP of the interface in $dhcp_interface, override
  # if you need to. You can make this a comma-separated string too - it
  # will be split into an array
  $dhcp_nameservers = 'default'
  # Omapi settings
  $dhcp_key_name       = ''
  $dhcp_key_secret     = ''

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

  $dns_forwarders = []

}
