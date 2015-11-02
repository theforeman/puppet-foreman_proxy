# The default parameters for the foreman proxy
class foreman_proxy::params {

  include ::tftp::params
  include ::puppet::params

  case $::osfamily {
    'RedHat': {
      # if set to true, no repo will be added by this module, letting you to
      # set it to some custom location.
      $custom_repo         = false
      $plugin_prefix       = 'rubygem-smart_proxy_'
      $foreman_api_package = 'rubygem-apipie-bindings'

      $dir     = '/usr/share/foreman-proxy'
      $etc     = '/etc'
      $shell   = '/bin/false'
      $user    = 'foreman-proxy'

      $puppetssh_command = '/usr/bin/puppet agent --onetime --no-usecacheonfailure'

      $dhcp_config = '/etc/dhcp/dhcpd.conf'
      $dhcp_leases = '/var/lib/dhcpd/dhcpd.leases'

      $keyfile  = '/etc/rndc.key'
      $nsupdate = 'bind-utils'

      $tftp_syslinux_filenames = ['/usr/share/syslinux/chain.c32',
                                  '/usr/share/syslinux/menu.c32',
                                  '/usr/share/syslinux/memdisk',
                                  '/usr/share/syslinux/pxelinux.0']
    }
    'Debian': {
      # if set to true, no repo will be added by this module, letting you to
      # set it to some custom location.
      $custom_repo         = false
      $plugin_prefix       = 'ruby-smart-proxy-'
      $foreman_api_package = 'ruby-apipie-bindings'

      $dir   = '/usr/share/foreman-proxy'
      $etc   = '/etc'
      $shell = '/bin/false'
      $user  = 'foreman-proxy'

      $puppetssh_command = '/usr/bin/puppet agent --onetime --no-usecacheonfailure'

      $dhcp_config = '/etc/dhcp/dhcpd.conf'
      $dhcp_leases = '/var/lib/dhcp/dhcpd.leases'

      $keyfile  = '/etc/bind/rndc.key'
      $nsupdate = 'dnsutils'
      if  ($::operatingsystem == 'Debian') and (versioncmp($::operatingsystemrelease, '8.0') >= 0) or
          ($::operatingsystem == 'Ubuntu') and (versioncmp($::operatingsystemrelease, '14.10') >= 0) {
        $tftp_syslinux_filenames = ['/usr/lib/PXELINUX/pxelinux.0',
                                    '/usr/lib/syslinux/memdisk',
                                    '/usr/lib/syslinux/modules/bios/chain.c32',
                                    '/usr/lib/syslinux/modules/bios/ldlinux.c32',
                                    '/usr/lib/syslinux/modules/bios/libutil.c32',
                                    '/usr/lib/syslinux/modules/bios/menu.c32']
      } else {
        $tftp_syslinux_filenames = ['/usr/lib/syslinux/chain.c32',
                                    '/usr/lib/syslinux/menu.c32',
                                    '/usr/lib/syslinux/memdisk',
                                    '/usr/lib/syslinux/pxelinux.0']
      }
    }
    /^(FreeBSD|DragonFly)$/: {
      # if set to true, no repo will be added by this module, letting you to
      # set it to some custom location.
      $custom_repo         = true # as foreman packages are in standard FreeBSD ports
      $plugin_prefix       = 'rubygem-smart_proxy_'
      $foreman_api_package = 'rubygem-apipie-bindings'

      $dir   = '/usr/local/share/foreman-proxy'
      $etc   = '/usr/local/etc'
      $shell = '/usr/bin/false'
      $user  = 'foreman_proxy'

      $puppetssh_command = '/usr/local/bin/puppet agent --onetime --no-usecacheonfailure'

      $dhcp_config = '/usr/local/etc/dhcp/dhcpd.conf'
      $dhcp_leases = '/var/db/dhcpd/dhcpd.leases'

      $keyfile  = '/usr/local/etc/namedb/rndc.key'
      $nsupdate = 'bind910'

      $tftp_syslinux_filenames = ['/usr/local/share/syslinux/bios/core/pxelinux.0',
                                  '/usr/local/share/syslinux/bios/memdisk/memdisk',
                                  '/usr/local/share/syslinux/bios/com32/chain/chain.c32',
                                  '/usr/local/share/syslinux/bios/com32/elflink/ldlinux/ldlinux.c32',
                                  '/usr/local/share/syslinux/bios/com32/libutil/libutil.c32',
                                  '/usr/local/share/syslinux/bios/com32/menu/menu.c32']
    }
    default: {
      fail("${::hostname}: This module does not support osfamily ${::osfamily}")
    }
  }

  # Packaging
  $repo           = 'stable'
  $gpgcheck       = true
  $version        = 'present'
  $plugin_version = 'installed'

  # variables
  $bind_host = '*'
  $port      = undef # deprecated in favor of $ssl_port/$http_port
  $log       = '/var/log/foreman-proxy/proxy.log'
  $log_level = 'ERROR'

  $puppet_home = $puppet::params::vardir

  # Enable listening on http
  $http      = false
  $http_port = '8000'

  # Enable SSL, ensure proxy is added with "https://" protocol if true
  $ssl      = true
  $ssl_port = '8443'
  # If CA is specified, remote Foreman host will be verified
  $ssl_ca = "${puppet_home}/ssl/certs/ca.pem"
  # Used to communicate to Foreman
  $ssl_cert = "${puppet_home}/ssl/certs/${::fqdn}.pem"
  $ssl_key  = "${puppet_home}/ssl/private_keys/${::fqdn}.pem"

  $foreman_ssl_ca  = undef
  $foreman_ssl_cert = undef
  $foreman_ssl_key  = undef

  # Only hosts listed will be permitted, empty array to disable authorization
  $trusted_hosts = [$::fqdn]

  $sudoers = "${etc}/sudoers"

  # Whether to manage File["$etc/sudoers.d"] or not.  When reusing this module,
  # this may be disabled to let a dedicated sudo module manage it instead.
  $manage_sudoersd = true

  # Add a file to /etc/sudoers.d (true) or uses augeas (false)
  $use_sudoersd = true

  # puppet settings
  $puppet_url                 = "https://${::fqdn}:8140"
  $puppet_use_environment_api = undef
  $puppet_use_cache           = undef
  $puppet_cache_location      = '/var/cache/foreman-proxy'

  # puppetca settings
  $puppetca           = true
  $puppetca_listen_on = 'https'
  $autosign_location  = "${etc}/puppet/autosign.conf"
  $puppetca_cmd       = $puppet::params::puppetca_cmd
  $puppet_group       = 'puppet'
  $ssldir             = "${puppet_home}/ssl"
  $puppetdir          = $puppet::params::dir

  # puppetrun settings
  $puppetrun           = true
  $puppetrun_listen_on = 'https'
  $puppetrun_cmd       = $puppet::params::puppetrun_cmd
  $puppetrun_provider  = undef
  $customrun_cmd       = $shell
  $customrun_args      = '-ay -f -s'
  $puppetssh_sudo      = false
  $puppetssh_user      = 'root'
  $puppetssh_keyfile   = "${etc}/foreman-proxy/id_rsa"
  $puppetssh_wait      = false
  $puppet_user         = 'root'
  $salt_puppetrun_cmd  = 'puppet.run'

  # Template settings
  $templates           = false
  $templates_listen_on = 'both'
  $template_url        = "http://${::fqdn}:${http_port}"

  # TFTP settings - requires optional TFTP puppet module
  $tftp             = true
  $tftp_listen_on   = 'https'
  $tftp_manage_wget = true
  $tftp_root        = $tftp::params::root
  $tftp_dirs        = ["${tftp_root}/pxelinux.cfg","${tftp_root}/boot"]
  $tftp_servername  = undef

  # TODO: remove these on the next major version bump
  $tftp_syslinux_root  = undef
  $tftp_syslinux_files = undef

  # DHCP settings - requires optional DHCP puppet module
  $dhcp                   = false
  $dhcp_listen_on         = 'https'
  $dhcp_managed           = true
  $dhcp_interface         = 'eth0'
  $dhcp_gateway           = '192.168.100.1'
  $dhcp_range             = false
  $dhcp_option_domain     = [$::domain]
  # This will use the IP of the interface in $dhcp_interface, override
  # if you need to. You can make this a comma-separated string too - it
  # will be split into an array
  $dhcp_nameservers = 'default'
  $dhcp_server      = '127.0.0.1'
  # Omapi settings
  $dhcp_key_name   = undef
  $dhcp_key_secret = undef
  $dhcp_omapi_port = 7911
  $dhcp_vendor     = 'isc'

  # DNS settings - requires optional DNS puppet module
  $dns                    = false
  $dns_split_config_files = true # smart-proxy 1.10+
  $dns_listen_on          = 'https'
  $dns_managed            = true
  $dns_provider           = 'nsupdate'
  $dns_interface          = 'eth0'
  $dns_zone               = $::domain
  $dns_realm              = upcase($dns_zone)
  $dns_reverse            = '100.168.192.in-addr.arpa'
  # localhost can resolve to ipv6 which ruby doesn't handle well
  $dns_server             = '127.0.0.1'
  $dns_ttl                = '86400'
  $dns_tsig_keytab        = "${etc}/foreman-proxy/dns.keytab"
  $dns_tsig_principal     = "foremanproxy/${::fqdn}@${dns_realm}"

  $dns_forwarders = []

  # virsh options
  $virsh_network = 'default'

  # BMC options
  $bmc                  = false
  $bmc_listen_on        = 'https'
  $bmc_default_provider = 'ipmitool'

  # Realm management options
  $realm              = false
  $realm_listen_on    = 'https'
  $realm_provider     = 'freeipa'
  $realm_keytab       = "${etc}/foreman-proxy/freeipa.keytab"
  $realm_principal    = 'realm-proxy@EXAMPLE.COM'
  $freeipa_remove_dns = true

  # Proxy can register itself within a Foreman instance
  $register_in_foreman = true
  # Foreman instance URL for registration
  $foreman_base_url = "https://${::fqdn}"
  # Name the proxy should be registered with
  $registered_name = $::fqdn
  # Proxy URL to be registered
  $registered_proxy_url = "https://${::fqdn}:${ssl_port}"
  # User to be used for registration
  $oauth_effective_user = 'admin'
  # OAuth credentials
  # shares cached_data with the foreman module so they're the same
  $oauth_consumer_key    = cache_data('foreman_cache_data', 'oauth_consumer_key', random_password(32))
  $oauth_consumer_secret = cache_data('foreman_cache_data', 'oauth_consumer_secret', random_password(32))
}
