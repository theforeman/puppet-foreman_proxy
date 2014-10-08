# The default parameters for the foreman proxy
class foreman_proxy::params {

  include tftp::params
  include puppet::params

  # Packaging
  $repo = 'stable'
  $gpgcheck = true
  # if set to true, no repo will be added by this module, letting you to
  # set it to some custom location.
  $custom_repo = false
  $version     = 'present'

  # variables
  $port = '8443'
  $dir  = '/usr/share/foreman-proxy'
  $user = 'foreman-proxy'
  $log  = '/var/log/foreman-proxy/proxy.log'

  $puppet_home = $puppet::params::server_vardir

  # Enable SSL, ensure proxy is added with "https://" protocol if true
  $ssl = true
  # If CA is specified, remote Foreman host will be verified
  $ssl_ca = "${puppet_home}/ssl/certs/ca.pem"
  # Used to communicate to Foreman
  $ssl_cert = "${puppet_home}/ssl/certs/${::fqdn}.pem"
  $ssl_key = "${puppet_home}/ssl/private_keys/${::fqdn}.pem"

  # Only hosts listed will be permitted, empty array to disable authorization
  $trusted_hosts = [$::fqdn]

  # Whether to manage File['/etc/sudoers.d'] or not.  When reusing this module,
  # this may be disabled to let a dedicated sudo module manage it instead.
  $manage_sudoersd = true

  # Add a file to /etc/sudoers.d (true) or uses augeas (false)
  case $::operatingsystem {
    redhat,centos,Scientific: {
      if versioncmp($::operatingsystemrelease, '6.0') >= 0 {
        $use_sudoersd = true
      } else {
        $use_sudoersd = false
      }
    }
    default: {
      $use_sudoersd = true
    }
  }

  # puppet settings
  $puppet_url = "https://${::fqdn}:8140"
  $puppet_use_environment_api = undef

  # puppetca settings
  $puppetca          = true
  $autosign_location = '/etc/puppet/autosign.conf'
  $puppetca_cmd      = $puppet::params::puppetca_cmd
  $puppet_group      = 'puppet'
  $ssldir            = "${puppet_home}/ssl"
  $puppetdir         = $puppet::params::dir

  # puppetrun settings
  $puppetrun          = true
  $puppetrun_cmd      = $puppet::params::puppetrun_cmd
  $puppetrun_provider = ''
  $customrun_cmd      = '/bin/false'
  $customrun_args     = '-ay -f -s'
  $puppetssh_sudo     = false
  $puppetssh_command  = '/usr/bin/puppet agent --onetime --no-usecacheonfailure'
  $puppetssh_user     = 'root'
  $puppetssh_keyfile  = '/etc/foreman-proxy/id_rsa'
  $puppet_user        = 'root'

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
  $tftp_syslinux_files = ['pxelinux.0','menu.c32','chain.c32','memdisk']
  $tftp_root           = $tftp::params::root
  $tftp_dirs           = ["${tftp_root}/pxelinux.cfg","${tftp_root}/boot"]
  $tftp_servername     = $::ipaddress_eth0 ? {
    undef   => $::ipaddress,
    default => $::ipaddress_eth0,
  }

  # DHCP settings - requires optional DHCP puppet module
  $dhcp             = false
  $dhcp_managed     = true
  $dhcp_interface   = 'eth0'
  $dhcp_gateway     = '192.168.100.1'
  $dhcp_range       = false
  # This will use the IP of the interface in $dhcp_interface, override
  # if you need to. You can make this a comma-separated string too - it
  # will be split into an array
  $dhcp_nameservers = 'default'
  # Omapi settings
  $dhcp_key_name       = ''
  $dhcp_key_secret     = ''

  # DHCP server settings
  case $::osfamily {
    Debian: {
      $dhcp_vendor = 'isc'
      $dhcp_config = '/etc/dhcp/dhcpd.conf'
      $dhcp_leases = '/var/lib/dhcp/dhcpd.leases'
    }
    RedHat: {
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
  $dns                = false
  $dns_managed        = true
  $dns_provider       = 'nsupdate'
  $dns_interface      = 'eth0'
  $dns_zone           = $::domain
  $dns_realm          = upcase($dns_zone)
  $dns_reverse        = '100.168.192.in-addr.arpa'
  # localhost can resolve to ipv6 which ruby doesn't handle well
  $dns_server         = '127.0.0.1'
  $dns_ttl            = '86400'
  $dns_tsig_keytab    = '/etc/foreman-proxy/dns.keytab'
  $dns_tsig_principal = "foremanproxy/${::fqdn}@${dns_realm}"
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

  # virsh options
  $virsh_network = 'default'

  # BMC options
  $bmc = false
  $bmc_default_provider = 'ipmitool'

  # Realm management options
  $realm = false
  $realm_provider = 'freeipa'
  $realm_keytab = '/etc/foreman-proxy/freeipa.keytab'
  $realm_principal = 'realm-proxy@EXAMPLE.COM'
  $freeipa_remove_dns = true

  # Proxy can register itself within a Foreman instance
  $register_in_foreman = true
  # Foreman instance URL for registration
  $foreman_base_url = "https://${::fqdn}"
  # Name the proxy should be registered with
  $registered_name = $::fqdn
  # Proxy URL to be registered
  $registered_proxy_url = "https://${::fqdn}:${port}"
  # User to be used for registration
  $oauth_effective_user = 'admin'
  # OAuth credentials
  # shares cached_data with the foreman module so they're the same
  $oauth_consumer_key = cache_data('oauth_consumer_key', random_password(32))
  $oauth_consumer_secret = cache_data('oauth_consumer_secret', random_password(32))

  $foreman_api_package = $::osfamily ? {
    Debian  => 'ruby-apipie-bindings',
    default => 'rubygem-apipie-bindings',
  }

  case $::osfamily {
    'RedHat': {
      $plugin_prefix = 'rubygem-smart_proxy_'
    }
    'Debian': {
      $plugin_prefix = 'ruby-smart-proxy-'
    }
    default: {
      $plugin_prefix = 'smart_proxy_'
    }
  }
}
