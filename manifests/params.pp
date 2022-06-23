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
      $shell = pick($foreman_proxy::globals::shell, '/bin/false')
      $user  = pick($foreman_proxy::globals::user, 'foreman-proxy')
      $group = pick($foreman_proxy::globals::group, 'foreman-proxy')

      $dhcp_config = '/etc/dhcp/dhcpd.conf'
      $dhcp_leases = '/var/lib/dhcpd/dhcpd.leases'
      $dhcp_manage_acls = true

      $keyfile  = '/etc/rndc.key'
      $nsupdate = 'bind-utils'

      if versioncmp($facts['os']['release']['major'], '7') <= 0 {
        $_tftp_syslinux_filenames = [
          '/usr/share/syslinux/chain.c32',
          '/usr/share/syslinux/mboot.c32',
          '/usr/share/syslinux/menu.c32',
          '/usr/share/syslinux/memdisk',
          '/usr/share/syslinux/pxelinux.0',
        ]
      } else {
        $_tftp_syslinux_filenames = [
          '/usr/share/syslinux/chain.c32',
          '/usr/share/syslinux/ldlinux.c32',
          '/usr/share/syslinux/libcom32.c32',
          '/usr/share/syslinux/libutil.c32',
          '/usr/share/syslinux/mboot.c32',
          '/usr/share/syslinux/menu.c32',
          '/usr/share/syslinux/memdisk',
          '/usr/share/syslinux/pxelinux.0',
        ]
      }
    }
    'Debian': {
      $ruby_package_prefix = 'ruby-'
      $plugin_prefix = "${ruby_package_prefix}smart-proxy-"

      $dir   = pick($foreman_proxy::globals::dir, '/usr/share/foreman-proxy')
      $etc   = '/etc'
      $shell = pick($foreman_proxy::globals::shell, '/bin/false')
      $user  = pick($foreman_proxy::globals::user, 'foreman-proxy')
      $group = pick($foreman_proxy::globals::group, 'foreman-proxy')

      $dhcp_config = '/etc/dhcp/dhcpd.conf'
      $dhcp_leases = '/var/lib/dhcp/dhcpd.leases'
      $dhcp_manage_acls = true

      $keyfile  = '/etc/bind/rndc.key'
      $nsupdate = 'dnsutils'

      $_tftp_syslinux_filenames = [
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
      $shell = pick($foreman_proxy::globals::shell, '/usr/bin/false')
      $user  = pick($foreman_proxy::globals::user, 'foreman_proxy')
      $group = pick($foreman_proxy::globals::group, 'foreman_proxy')

      $puppet_bindir = '/usr/local/bin'
      $puppetdir     = '/usr/local/etc/puppet'
      $ssldir        = '/var/puppet/ssl'

      $dhcp_config = '/usr/local/etc/dhcpd.conf'
      $dhcp_leases = '/var/db/dhcpd/dhcpd.leases'
      $dhcp_manage_acls = false

      $keyfile  = '/usr/local/etc/namedb/rndc.key'
      $nsupdate = 'bind-tools'

      $_tftp_syslinux_filenames = [
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

  $tftp_syslinux_filenames = pick($foreman_proxy::globals::tftp_syslinux_filenames, $_tftp_syslinux_filenames)

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

  # If CA is specified, remote Foreman host will be verified
  $ssl_ca = "${ssldir}/certs/ca.pem"
  # Used to communicate to Foreman
  $ssl_cert = "${ssldir}/certs/${lower_fqdn}.pem"
  $ssl_key = "${ssldir}/private_keys/${lower_fqdn}.pem"

  # Only hosts listed will be permitted, empty array to disable authorization
  $trusted_hosts = [$lower_fqdn]

  $sudoers = "${etc}/sudoers"

  # puppet settings
  $puppet_url = "https://${facts['networking']['fqdn']}:8140"

  # puppetca settings
  $puppetca_cmd = "${puppet_cmd} cert"
  $autosignfile = "${puppetdir}/autosign.conf"

  # Template settings
  $template_url = "http://${facts['networking']['fqdn']}:8000"

  # TFTP settings - requires optional TFTP puppet module
  $tftp_root = lookup('tftp::root', undef, undef, undef)

  # DHCP settings - requires optional DHCP puppet module
  $dhcp_interface        = pick(fact('networking.primary'), 'eth0')
  if fact('networking.domain') {
    $dhcp_option_domain  = [$facts['networking']['domain']]
  } else {
    $dhcp_option_domain  = []
  }
  $dhcp_failover_address = fact('networking.ip')

  # DNS settings - requires optional DNS puppet module
  $dns_interface      = pick(fact('networking.primary'), 'eth0')
  $dns_zone           = $facts['networking']['domain']
  if $dns_zone {
    $dns_realm        = upcase($dns_zone)
  } else {
    $dns_realm        = undef
  }
  $dns_tsig_keytab    = "${config_dir}/dns.keytab"
  $dns_tsig_principal = "foremanproxy/${facts['networking']['fqdn']}@${dns_realm}"

  # Realm management options
  $realm_keytab    = "${config_dir}/freeipa.keytab"
  $realm_principal = "realm-proxy@${dns_realm}"

  # Foreman instance URL for registration
  $foreman_base_url = "https://${lower_fqdn}"
  # Name the proxy should be registered with
  $registered_name = $facts['networking']['fqdn']
  # OAuth credentials
  # shares cached_data with the foreman module so they're the same
  $oauth_consumer_key    = extlib::cache_data('foreman_cache_data', 'oauth_consumer_key', extlib::random_password(32))
  $oauth_consumer_secret = extlib::cache_data('foreman_cache_data', 'oauth_consumer_secret', extlib::random_password(32))
}
