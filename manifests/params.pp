# @summary The default parameters for the foreman proxy
# @api private
class foreman_proxy::params inherits foreman_proxy::globals {

  $lower_fqdn = downcase($facts['networking']['fqdn'])

  case $facts['os']['family'] {
    'RedHat': {
      if versioncmp($facts['os']['release']['major'], '7') <= 0 {
        $ruby_package_prefix = 'tfm-rubygem-'
      } else {
        $ruby_package_prefix = 'rubygem-'
      }
      $plugin_prefix = "${ruby_package_prefix}smart_proxy_"

      $dir   = pick($foreman_proxy::globals::dir, '/usr/share/foreman-proxy')
      $etc   = '/etc'
      $shell = '/bin/false'
      $user  = pick($foreman_proxy::globals::user, 'foreman-proxy')

      $dhcp_config = '/etc/dhcp/dhcpd.conf'
      $dhcp_leases = '/var/lib/dhcpd/dhcpd.leases'
      $dhcp_manage_acls = true

      $keyfile  = '/etc/rndc.key'
      $nsupdate = 'bind-utils'

      $tftp_root  = '/var/lib/tftpboot'
      $tftp_syslinux_filenames = [
        '/usr/share/syslinux/chain.c32',
        '/usr/share/syslinux/mboot.c32',
        '/usr/share/syslinux/menu.c32',
        '/usr/share/syslinux/memdisk',
        '/usr/share/syslinux/pxelinux.0',
      ]
    }
    'Debian': {
      $ruby_package_prefix = 'ruby-'
      $plugin_prefix = "${ruby_package_prefix}smart-proxy-"

      $dir   = pick($foreman_proxy::globals::dir, '/usr/share/foreman-proxy')
      $etc   = '/etc'
      $shell = '/bin/false'
      $user  = pick($foreman_proxy::globals::user, 'foreman-proxy')

      $dhcp_config = '/etc/dhcp/dhcpd.conf'
      $dhcp_leases = '/var/lib/dhcp/dhcpd.leases'
      $dhcp_manage_acls = false

      $keyfile  = '/etc/bind/rndc.key'
      $nsupdate = 'dnsutils'

      if $facts['os']['name'] == 'Ubuntu' {
        $tftp_root = '/var/lib/tftpboot'
      } else {
        $tftp_root = '/srv/tftp'
      }
      $tftp_syslinux_filenames = [
        '/usr/lib/PXELINUX/pxelinux.0',
        '/usr/lib/syslinux/memdisk',
        '/usr/lib/syslinux/modules/bios/chain.c32',
        '/usr/lib/syslinux/modules/bios/ldlinux.c32',
        '/usr/lib/syslinux/modules/bios/libcom32.c32',
        '/usr/lib/syslinux/modules/bios/libutil.c32',
        '/usr/lib/syslinux/modules/bios/mboot.c32',
        '/usr/lib/syslinux/modules/bios/menu.c32',
      ]
    }
    /^(FreeBSD|DragonFly)$/: {
      $ruby_package_prefix = 'rubygem-'
      $plugin_prefix = "${ruby_package_prefix}smart_proxy_"

      $dir   = pick($foreman_proxy::globals::dir, '/usr/local/share/foreman-proxy')
      $etc   = '/usr/local/etc'
      $shell = '/usr/bin/false'
      $user  = pick($foreman_proxy::globals::user, 'foreman_proxy')

      $puppet_bindir = '/usr/local/bin'
      $puppetdir     = '/usr/local/etc/puppet'
      $ssldir        = '/var/puppet/ssl'

      $dhcp_config = '/usr/local/etc/dhcpd.conf'
      $dhcp_leases = '/var/db/dhcpd/dhcpd.leases'
      $dhcp_manage_acls = false

      $keyfile  = '/usr/local/etc/namedb/rndc.key'
      $nsupdate = 'bind-tools'

      $tftp_root = '/tftpboot'
      $tftp_syslinux_filenames = [
        '/usr/local/share/syslinux/bios/core/pxelinux.0',
        '/usr/local/share/syslinux/bios/memdisk/memdisk',
        '/usr/local/share/syslinux/bios/com32/chain/chain.c32',
        '/usr/local/share/syslinux/bios/com32/elflink/ldlinux/ldlinux.c32',
        '/usr/local/share/syslinux/bios/com32/lib/libcom32.c32',
        '/usr/local/share/syslinux/bios/com32/libutil/libutil.c32',
        '/usr/local/share/syslinux/bios/com32/mboot/mboot.c32',
        '/usr/local/share/syslinux/bios/com32/menu/menu.c32',
      ]
    }
    default: {
      fail("${facts['networking']['hostname']}: This module does not support osfamily ${facts['os']['family']}")
    }
  }

  if $facts['os']['family'] !~ /^(FreeBSD|DragonFly)$/ {
    if fact('aio_agent_version') =~ String[1] {
      $puppet_bindir = '/opt/puppetlabs/bin'
      $puppetdir     = '/etc/puppetlabs/puppet'
      $ssldir        = "${puppetdir}/ssl"
    } else {
      $puppet_bindir = '/usr/bin'
      $puppetdir     = '/etc/puppet'
      $ssldir        = '/var/lib/puppet/ssl'
    }
  }

  if fact('aio_agent_version') =~ String[1] {
    $puppetcodedir = '/etc/puppetlabs/code'
  } else {
    $puppetcodedir = "${puppetdir}/code"
  }

  $config_dir = "${etc}/foreman-proxy"

  $puppet_cmd = "${puppet_bindir}/puppet"

  $groups = []

  # Packaging
  $repo                    = undef
  $gpgcheck                = true
  $version                 = 'present'
  $ensure_packages_version = 'present'

  # Enable listening on http
  $bind_host = ['*']
  $http      = false
  $http_port = 8000

  # Logging settings
  $log               = '/var/log/foreman-proxy/proxy.log'
  $log_level         = 'INFO'
  $log_buffer        = 2000
  $log_buffer_errors = 1000

  # Enable SSL, ensure proxy is added with "https://" protocol if true
  $ssl      = true
  $ssl_port = 8443
  # If CA is specified, remote Foreman host will be verified
  $ssl_ca = "${ssldir}/certs/ca.pem"
  # Used to communicate to Foreman
  $ssl_cert = "${ssldir}/certs/${lower_fqdn}.pem"
  $ssl_key = "${ssldir}/private_keys/${lower_fqdn}.pem"
  $ssl_disabled_ciphers = []
  $tls_disabled_versions = []

  $foreman_ssl_ca  = undef
  $foreman_ssl_cert = undef
  $foreman_ssl_key  = undef

  # Only hosts listed will be permitted, empty array to disable authorization
  $trusted_hosts = [$lower_fqdn]

  $sudoers = "${etc}/sudoers"

  # Whether to manage File["$etc/sudoers.d"] or not.  When reusing this module,
  # this may be disabled to let a dedicated sudo module manage it instead.
  $manage_sudoersd = true

  # Setting both $use_sudoersd and $use_sudoers to false means this module will not
  # touch any sudoers entries. Setting both to true will result in sudoersd winning.
  # Add a file to /etc/sudoers.d (true).
  $use_sudoersd = true

  # Add contents to /etc/sudoers (true, only if $use_sudoers is false).
  $use_sudoers = true

  # puppet settings
  $puppet_url                 = "https://${facts['networking']['fqdn']}:8140"
  $puppet_api_timeout         = 30

  # puppetca settings
  $puppetca              = true
  $puppetca_provider     = 'puppetca_hostname_whitelisting'
  $puppetca_listen_on    = 'https'
  $puppetca_cmd          = "${puppet_cmd} cert"
  $puppet_group          = 'puppet'
  $autosignfile          = "${puppetdir}/autosign.conf"
  $puppetca_sign_all     = false
  $puppetca_tokens_file  = '/var/lib/foreman-proxy/tokens.yml'
  $puppetca_token_ttl    = 360
  $puppetca_certificate  = undef

  # The puppet-agent package, (puppet 4 AIO) doesn't create a puppet group
  $manage_puppet_group = versioncmp($::puppetversion, '4.0') > 0

  # puppetrun settings
  $puppet = true
  $puppet_listen_on = 'https'

  $puppetrun_provider  = undef
  $customrun_cmd       = $shell
  $customrun_args      = '-ay -f -s'
  $mcollective_user    = 'root'
  $puppetssh_command   = "${puppet_cmd} agent --onetime --no-usecacheonfailure"
  $puppetssh_sudo      = false
  $puppetssh_user      = 'root'
  $puppetssh_keyfile   = "${config_dir}/id_rsa"
  $puppetssh_wait      = false
  $puppet_user         = 'root'
  $salt_puppetrun_cmd  = 'puppet.run'

  # Template settings
  $templates           = false
  $templates_listen_on = 'both'
  $template_url        = "http://${facts['networking']['fqdn']}:${http_port}"

  # Logs settings
  $logs           = true
  $logs_listen_on = 'https'

  # HTTPBoot settings - requires optional httpboot puppet module
  $httpboot           = undef
  $httpboot_listen_on = 'both'

  # TFTP settings - requires optional TFTP puppet module
  $tftp                   = false
  $tftp_listen_on         = 'https'
  $tftp_managed           = true
  $tftp_manage_wget       = true
  $tftp_dirs              = ["${tftp_root}/pxelinux.cfg","${tftp_root}/grub","${tftp_root}/grub2","${tftp_root}/boot","${tftp_root}/ztp.cfg","${tftp_root}/poap.cfg"]
  $tftp_servername        = undef
  $tftp_replace_grub2_cfg = false

  # DHCP settings - requires optional DHCP puppet module
  $dhcp                    = false
  $dhcp_listen_on          = 'https'
  $dhcp_managed            = true
  $dhcp_provider           = 'isc'
  $dhcp_subnets            = []
  $dhcp_interface          = pick(fact('networking.primary'), 'eth0')
  $dhcp_additional_interfaces = []
  $dhcp_gateway            = undef
  $dhcp_range              = undef
  $dhcp_option_domain      = [$facts['networking']['domain']]
  $dhcp_search_domains     = undef
  $dhcp_pxeserver          = undef
  $dhcp_pxefilename        = 'pxelinux.0'
  $dhcp_network            = undef
  $dhcp_netmask            = undef
  # This will use the IP of the interface in $dhcp_interface, override
  # if you need to. You can make this a comma-separated string too - it
  # will be split into an array
  $dhcp_nameservers = 'default'
  $dhcp_server      = '127.0.0.1'
  # Omapi settings
  $dhcp_key_name   = undef
  $dhcp_key_secret = undef
  $dhcp_omapi_port = 7911
  $dhcp_node_type = 'standalone'
  $dhcp_failover_address = fact('ipaddress')
  $dhcp_peer_address = undef
  $dhcp_failover_port = 519
  $dhcp_max_response_delay = 30
  $dhcp_max_unacked_updates  = 10
  $dhcp_mclt  = 300
  $dhcp_load_split = 255
  $dhcp_load_balance = 3

  # DNS settings - requires optional DNS puppet module
  $dns                    = false
  $dns_listen_on          = 'https'
  $dns_managed            = true
  $dns_provider           = 'nsupdate'
  $dns_interface          = pick(fact('networking.primary'), 'eth0')
  $dns_zone               = $facts['networking']['domain']
  if $dns_zone {
    $dns_realm            = upcase($dns_zone)
  } else {
    $dns_realm            = undef
  }
  $dns_reverse            = undef
  # localhost can resolve to ipv6 which ruby doesn't handle well
  $dns_server             = '127.0.0.1'
  $dns_ttl                = 86400
  $dns_tsig_keytab        = "${config_dir}/dns.keytab"
  $dns_tsig_principal     = "foremanproxy/${facts['networking']['fqdn']}@${dns_realm}"

  $dns_forwarders = []

  # libvirt options
  $libvirt_connection = 'qemu:///system'
  $libvirt_network    = 'default'

  # BMC options
  $bmc                  = false
  $bmc_listen_on        = 'https'
  $bmc_default_provider = 'ipmitool'
  $bmc_ssh_user         = 'root'
  $bmc_ssh_key          = '/usr/share/foreman/.ssh/id_rsa'
  $bmc_ssh_powercycle   = 'shutdown -r +1'
  $bmc_ssh_poweroff     = 'shutdown +1'
  # lint:ignore:quoted_booleans
  $bmc_ssh_poweron      = 'false'
  $bmc_ssh_powerstatus  = 'true'
  # lint:endignore

  # Realm management options
  $realm              = false
  $realm_listen_on    = 'https'
  $realm_provider     = 'freeipa'
  $realm_keytab       = "${config_dir}/freeipa.keytab"
  $realm_principal    = 'realm-proxy@EXAMPLE.COM'
  $freeipa_config     = '/etc/ipa/default.conf'
  $freeipa_remove_dns = true

  # Proxy can register itself within a Foreman instance
  $register_in_foreman = true
  # Foreman instance URL for registration
  $foreman_base_url = "https://${lower_fqdn}"
  # Name the proxy should be registered with
  $registered_name = $facts['networking']['fqdn']
  # Proxy URL to be registered
  $registered_proxy_url = undef
  # User to be used for registration
  $oauth_effective_user = 'admin'
  # OAuth credentials
  # shares cached_data with the foreman module so they're the same
  $oauth_consumer_key    = extlib::cache_data('foreman_cache_data', 'oauth_consumer_key', extlib::random_password(32))
  $oauth_consumer_secret = extlib::cache_data('foreman_cache_data', 'oauth_consumer_secret', extlib::random_password(32))
}
