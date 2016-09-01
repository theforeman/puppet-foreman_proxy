# The default parameters for the foreman proxy
class foreman_proxy::params {

  $lower_fqdn = downcase($::fqdn)

  case $::osfamily {
    'RedHat': {
      # if set to true, no repo will be added by this module, letting you to
      # set it to some custom location.
      $custom_repo         = false
      $plugin_prefix       = 'rubygem-smart_proxy_'

      $dir     = '/usr/share/foreman-proxy'
      $etc     = '/etc'
      $shell   = '/bin/false'
      $user    = 'foreman-proxy'
      $puppet_home = '/var/lib/puppet'

      $puppetssh_command = '/usr/bin/puppet agent --onetime --no-usecacheonfailure'

      $dhcp_config = '/etc/dhcp/dhcpd.conf'
      $dhcp_leases = '/var/lib/dhcpd/dhcpd.leases'

      $keyfile  = '/etc/rndc.key'
      $nsupdate = 'bind-utils'

      $tftp_root  = '/var/lib/tftpboot'
      $tftp_syslinux_filenames = ['/usr/share/syslinux/chain.c32',
                                  '/usr/share/syslinux/mboot.c32',
                                  '/usr/share/syslinux/menu.c32',
                                  '/usr/share/syslinux/memdisk',
                                  '/usr/share/syslinux/pxelinux.0']
    }
    'Debian': {
      # if set to true, no repo will be added by this module, letting you to
      # set it to some custom location.
      $custom_repo         = false
      $plugin_prefix       = 'ruby-smart-proxy-'

      $dir   = '/usr/share/foreman-proxy'
      $etc   = '/etc'
      $shell = '/bin/false'
      $user  = 'foreman-proxy'
      $puppet_home = '/var/lib/puppet'

      $puppetssh_command = '/usr/bin/puppet agent --onetime --no-usecacheonfailure'

      $dhcp_config = '/etc/dhcp/dhcpd.conf'
      $dhcp_leases = '/var/lib/dhcp/dhcpd.leases'

      $keyfile  = '/etc/bind/rndc.key'
      $nsupdate = 'dnsutils'

      if $::operatingsystem == 'Ubuntu' {
        $tftp_root = '/var/lib/tftpboot'
      } else {
        $tftp_root = '/srv/tftp'
      }
      if $::operatingsystem == 'Ubuntu' and $::operatingsystemrelease == '14.04' {
        $tftp_syslinux_filenames = ['/usr/lib/syslinux/chain.c32',
                                    '/usr/lib/syslinux/mboot.c32',
                                    '/usr/lib/syslinux/menu.c32',
                                    '/usr/lib/syslinux/memdisk',
                                    '/usr/lib/syslinux/pxelinux.0']
      } else {
        $tftp_syslinux_filenames = ['/usr/lib/PXELINUX/pxelinux.0',
                                    '/usr/lib/syslinux/memdisk',
                                    '/usr/lib/syslinux/modules/bios/chain.c32',
                                    '/usr/lib/syslinux/modules/bios/ldlinux.c32',
                                    '/usr/lib/syslinux/modules/bios/libcom32.c32',
                                    '/usr/lib/syslinux/modules/bios/libutil.c32',
                                    '/usr/lib/syslinux/modules/bios/mboot.c32',
                                    '/usr/lib/syslinux/modules/bios/menu.c32']
      }
    }
    /^(FreeBSD|DragonFly)$/: {
      # if set to true, no repo will be added by this module, letting you to
      # set it to some custom location.
      $custom_repo         = true # as foreman packages are in standard FreeBSD ports
      $plugin_prefix       = 'rubygem-smart_proxy_'

      $dir   = '/usr/local/share/foreman-proxy'
      $etc   = '/usr/local/etc'
      $shell = '/usr/bin/false'
      $user  = 'foreman_proxy'
      $puppet_home = '/var/puppet'
      $puppet_bindir = '/usr/local/bin'
      $puppetdir = '/usr/local/etc/puppet'
      $ssldir = "${puppet_home}/ssl"

      $puppetssh_command = "${puppet_bindir}/puppet agent --onetime --no-usecacheonfailure"

      $dhcp_config = '/usr/local/etc/dhcpd.conf'
      $dhcp_leases = '/var/db/dhcpd/dhcpd.leases'

      $keyfile  = '/usr/local/etc/namedb/rndc.key'
      $nsupdate = 'bind910'

      $tftp_root = '/tftpboot'
      $tftp_syslinux_filenames = ['/usr/local/share/syslinux/bios/core/pxelinux.0',
                                  '/usr/local/share/syslinux/bios/memdisk/memdisk',
                                  '/usr/local/share/syslinux/bios/com32/chain/chain.c32',
                                  '/usr/local/share/syslinux/bios/com32/elflink/ldlinux/ldlinux.c32',
                                  '/usr/local/share/syslinux/bios/com32/lib/libcom32.c32',
                                  '/usr/local/share/syslinux/bios/com32/libutil/libutil.c32',
                                  '/usr/local/share/syslinux/bios/com32/mboot/mboot.c32',
                                  '/usr/local/share/syslinux/bios/com32/menu/menu.c32']
    }
    default: {
      fail("${::hostname}: This module does not support osfamily ${::osfamily}")
    }
  }

  if versioncmp($::puppetversion, '4.0') < 0 {
    $aio_package = false
  } elsif $::rubysitedir =~ /\/opt\/puppetlabs\/puppet/ {
    $aio_package = true
  } else {
    $aio_package = false
  }

  if $::osfamily !~ /^(FreeBSD|DragonFly)$/ {
    if $aio_package {
      $puppetdir = '/etc/puppetlabs/puppet'
      $ssldir = "${puppetdir}/ssl"
      $puppet_bindir = '/opt/puppetlabs/bin'
    } else {
      $ssldir = "${puppet_home}/ssl"
      $puppet_bindir = '/usr/bin'
      $puppetdir = '/etc/puppet'
    }
  }

  $puppet_cmd = "${puppet_bindir}/puppet"

  # Packaging
  $repo                    = 'stable'
  $gpgcheck                = true
  $version                 = 'present'
  $ensure_packages_version = 'present'
  $plugin_version          = 'installed'

  # Enable listening on http
  $bind_host = '*'
  $http      = false
  $http_port = '8000'

  # Logging settings
  $log               = '/var/log/foreman-proxy/proxy.log'
  $log_level         = 'INFO'
  $log_buffer        = 2000
  $log_buffer_errors = 1000

  # Enable SSL, ensure proxy is added with "https://" protocol if true
  $ssl      = true
  $ssl_port = '8443'
  # If CA is specified, remote Foreman host will be verified
  $ssl_ca = "${ssldir}/certs/ca.pem"
  # Used to communicate to Foreman
  $ssl_cert = "${ssldir}/certs/${lower_fqdn}.pem"
  $ssl_key = "${ssldir}/private_keys/${lower_fqdn}.pem"
  $ssl_disabled_ciphers = []

  $foreman_ssl_ca  = undef
  $foreman_ssl_cert = undef
  $foreman_ssl_key  = undef

  # Only hosts listed will be permitted, empty array to disable authorization
  $trusted_hosts = [$lower_fqdn]

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

  # puppetca settings
  $puppetca           = true
  $puppetca_listen_on = 'https'
  $puppetca_cmd       = "${puppet_cmd} cert"
  $puppet_group       = 'puppet'

  # The puppet-agent package, (puppet 4 AIO) doesn't create a puppet group
  $manage_puppet_group = versioncmp($::puppetversion, '4.0') > 0

  # puppetrun settings
  $puppet = true
  $puppet_listen_on = 'https'

  $puppetrun_cmd       = "${puppet_cmd} kick"
  $puppetrun_provider  = undef
  $customrun_cmd       = $shell
  $customrun_args      = '-ay -f -s'
  $mcollective_user    = 'root'
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

  # Logs settings
  $logs           = true
  $logs_listen_on = 'https'

  # TFTP settings - requires optional TFTP puppet module
  $tftp             = true
  $tftp_listen_on   = 'https'
  $tftp_managed     = true
  $tftp_manage_wget = true
  $tftp_dirs        = ["${tftp_root}/pxelinux.cfg","${tftp_root}/grub","${tftp_root}/grub2","${tftp_root}/boot","${tftp_root}/ztp.cfg","${tftp_root}/poap.cfg"]
  $tftp_servername  = undef

  # DHCP settings - requires optional DHCP puppet module
  $dhcp                    = false
  $dhcp_listen_on          = 'https'
  $dhcp_managed            = true
  $dhcp_provider           = 'isc'
  $dhcp_subnets            = []
  $dhcp_interface          = 'eth0'
  $dhcp_gateway            = '192.168.100.1'
  $dhcp_range              = false
  $dhcp_option_domain      = [$::domain]
  $dhcp_search_domains     = undef
  # This will use the IP of the interface in $dhcp_interface, override
  # if you need to. You can make this a comma-separated string too - it
  # will be split into an array
  $dhcp_nameservers = 'default'
  $dhcp_server      = '127.0.0.1'
  # Omapi settings
  $dhcp_key_name   = undef
  $dhcp_key_secret = undef
  $dhcp_omapi_port = 7911

  # DNS settings - requires optional DNS puppet module
  $dns                    = false
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

  # libvirt options
  $libvirt_connection = 'qemu:///system'
  $libvirt_network    = 'default'

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
  $foreman_base_url = "https://${lower_fqdn}"
  # Name the proxy should be registered with
  $registered_name = $::fqdn
  # Proxy URL to be registered
  $registered_proxy_url = undef
  # User to be used for registration
  $oauth_effective_user = 'admin'
  # OAuth credentials
  # shares cached_data with the foreman module so they're the same
  $oauth_consumer_key    = cache_data('foreman_cache_data', 'oauth_consumer_key', random_password(32))
  $oauth_consumer_secret = cache_data('foreman_cache_data', 'oauth_consumer_secret', random_password(32))
}
