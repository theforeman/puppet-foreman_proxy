# Install, configure and run a foreman proxy
#
# === Parameters:
#
# $repo::                   This can be stable, rc, or nightly
#
# $gpgcheck::               Turn on/off gpg check in repo files (effective only on RedHat family systems)
#                           type:boolean
#
# $custom_repo::            No need to change anything here by default
#                           if set to true, no repo will be added by this module, letting you to
#                           set it to some custom location.
#                           type:boolean
#
# $port::                   Port on which will foreman proxy listen
#                           type:integer
#
# $dir::                    Foreman proxy install directory
#
# $user::                   User under which foreman proxy will run
#
# $log::                    Foreman proxy log file
#
# $ssl::                    Enable SSL, ensure proxy is added with "https://" protocol if true
#                           type:boolean
#
# $ssl_ca::                 If CA is specified, remote Foreman host will be verified
#
# $ssl_cert::               Used to communicate to Foreman
#
# $ssl_key::                Corresponding key to a certificate
#
# $trusted_hosts::          Only hosts listed will be permitted, empty array to disable authorization
#                           type:array
#
# $manage_sudoersd::        Whether to manage File['/etc/sudoers.d'] or not.  When reusing this module, this may be
#                           disabled to let a dedicated sudo module manage it instead.
#                           type:boolean
#
# $use_sudoersd::           Add a file to /etc/sudoers.d (true) or uses augeas (false)
#                           type:boolean
#
# $puppetca::               Use Puppet CA
#                           type:boolean
#
# $ssldir::                 Puppet CA ssl directory
#
# $puppetdir::              Puppet var directory
#
# $autosign_location::      Path to autosign configuration file
#
# $puppetca_cmd::           Puppet CA command to be allowed in sudoers
#
# $puppet_group::           Groups of Foreman proxy user
#
# $puppetrun::              Enable puppet run/kick management
#                           type:boolean
#
# $puppetrun_provider::     Set puppet_provider to handle puppet run/kick via mcollective
#
# $puppetrun_cmd::          Puppet run/kick command to be allowed in sudoers
#
# $customrun_cmd::          Puppet customrun command
#
# $customrun_args::         Puppet customrun command arguments
#
# $puppetssh_sudo::         Whether to use sudo before commands when using puppetrun_provider puppetssh
#                           type:boolean
#
# $puppetssh_command::      The command used by puppetrun_provider puppetssh
#
# $puppetssh_user::         The user for puppetrun_provider puppetssh
#
# $puppetssh_keyfile::      The keyfile for puppetrun_provider puppetssh commands
#
# $puppet_user::            Which user to invoke sudo as to run puppet commands
#
# $pulp::                   Pulp is installed on this host
#                           type:boolean
#
# $tftp::                   Use TFTP
#                           type:boolean
#
# $tftp_syslinux_root::     Directory that hold syslinux files
#
# $tftp_syslinux_files::    Syslinux files to install on TFTP (copied from $tftp_syslinux_root)
#                           type:array
#
# $tftp_root::              TFTP root directory
#
# $tftp_dirs::              Directories to be create in $tftp_root
#                           type:array
#
# $tftp_servername::        Defines the TFTP Servername to use, overrides the name in the subnet declaration
#
# $dhcp::                   Use DHCP
#                           type:boolean
#
# $dhcp_managed::           DHCP is managed by Foreman proxy
#                           type:boolean
#
# $dhcp_interface::         DHCP listen interface
#
# $dhcp_gateway::           DHCP pool gateway
#
# $dhcp_range::             Space-separated DHCP pool range
#
# $dhcp_nameservers::       DHCP nameservers
#
# $dhcp_vendor::            DHCP vendor
#
# $dhcp_config::            DHCP config file path
#
# $dhcp_leases::            DHCP leases file
#
# $dhcp_key_name::          DHCP key name
#
# $dhcp_key_secret::        DHCP password
#
# $dns::                    Use DNS
#                           type:boolean
#
# $dns_managed::            DNS is managed by Foreman proxy
#                           type:boolean
#
# $dns_provider::           DNS provider
#
# $dns_interface::          DNS interface
#
# $dns_zone::               DNS zone name
#
# $dns_reverse::            DNS reverse zone name
#
# $dns_server::             Address of DNS server to manage
#
# $dns_ttl::                DNS default TTL override
#
# $dns_tsig_keytab::        Kerberos keytab for DNS updates using GSS-TSIG authentication
#
# $dns_tsig_principal::     Kerberos principal for DNS updates using GSS-TSIG authentication
#
# $dns_forwarders::         DNS forwarders
#                           type:array
#
# $virsh_network::          Network for virsh DNS/DHCP provider
#
# $bmc::                    Use BMC
#                           type:boolean
#
# $bmc_default_provider::   BMC default provider.
#
# $keyfile::                DNS server keyfile path
#
# $realm::                  Use realm management
#                           type:boolean
#
# $realm_provider::         Realm management provider
#
# $realm_keytab::           Kerberos keytab path to authenticate realm updates
#
# $realm_principal::        Kerberos principal for realm updates
#
# $freeipa_remove_dns::     Remove DNS entries from FreeIPA when deleting hosts from realm
#                           type:boolean
#
# $register_in_foreman::    Register proxy back in Foreman
#                           type:boolean
#
# $registered_name::        Proxy name which is registered in Foreman
#
# $registered_proxy_url::   Proxy URL which is registered in Foreman
#
# $foreman_base_url::       Base Foreman URL used for REST interaction
#
# $oauth_effective_user::   User to be used for REST interaction
#
# $oauth_consumer_key::     OAuth key to be used for REST interaction
#
# $oauth_consumer_secret::  OAuth secret to be used for REST interaction
#
class foreman_proxy (
  $repo                  = $foreman_proxy::params::repo,
  $gpgcheck              = $foreman_proxy::params::gpgcheck,
  $custom_repo           = $foreman_proxy::params::custom_repo,
  $port                  = $foreman_proxy::params::port,
  $dir                   = $foreman_proxy::params::dir,
  $user                  = $foreman_proxy::params::user,
  $log                   = $foreman_proxy::params::log,
  $ssl                   = $foreman_proxy::params::ssl,
  $ssl_ca                = $foreman_proxy::params::ssl_ca,
  $ssl_cert              = $foreman_proxy::params::ssl_cert,
  $ssl_key               = $foreman_proxy::params::ssl_key,
  $trusted_hosts         = $foreman_proxy::params::trusted_hosts,
  $manage_sudoersd       = $foreman_proxy::params::manage_sudoersd,
  $use_sudoersd          = $foreman_proxy::params::use_sudoersd,
  $puppetca              = $foreman_proxy::params::puppetca,
  $ssldir                = $foreman_proxy::params::ssldir,
  $puppetdir             = $foreman_proxy::params::puppetdir,
  $autosign_location     = $foreman_proxy::params::autosign_location,
  $puppetca_cmd          = $foreman_proxy::params::puppetca_cmd,
  $puppet_group          = $foreman_proxy::params::puppet_group,
  $puppetrun             = $foreman_proxy::params::puppetrun,
  $puppetrun_cmd         = $foreman_proxy::params::puppetrun_cmd,
  $puppetrun_provider    = $foreman_proxy::params::puppetrun_provider,
  $customrun_cmd         = $foreman_proxy::params::customrun_cmd,
  $customrun_args        = $foreman_proxy::params::customrun_args,
  $puppetssh_sudo        = $foreman_proxy::params::puppetssh_sudo,
  $puppetssh_command     = $foreman_proxy::params::puppetssh_command,
  $puppetssh_user        = $foreman_proxy::params::puppetssh_user,
  $puppetssh_keyfile     = $foreman_proxy::params::puppetssh_keyfile,
  $puppet_user           = $foreman_proxy::params::puppet_user,
  $tftp                  = $foreman_proxy::params::tftp,
  $tftp_syslinux_root    = $foreman_proxy::params::tftp_syslinux_root,
  $tftp_syslinux_files   = $foreman_proxy::params::tftp_syslinux_files,
  $tftp_root             = $foreman_proxy::params::tftp_root,
  $tftp_dirs             = $foreman_proxy::params::tftp_dirs,
  $tftp_servername       = $foreman_proxy::params::tftp_servername,
  $dhcp                  = $foreman_proxy::params::dhcp,
  $dhcp_managed          = $foreman_proxy::params::dhcp_managed,
  $dhcp_interface        = $foreman_proxy::params::dhcp_interface,
  $dhcp_gateway          = $foreman_proxy::params::dhcp_gateway,
  $dhcp_range            = $foreman_proxy::params::dhcp_range,
  $dhcp_nameservers      = $foreman_proxy::params::dhcp_nameservers,
  $dhcp_vendor           = $foreman_proxy::params::dhcp_vendor,
  $dhcp_config           = $foreman_proxy::params::dhcp_config,
  $dhcp_leases           = $foreman_proxy::params::dhcp_leases,
  $dhcp_key_name         = $foreman_proxy::params::dhcp_key_name,
  $dhcp_key_secret       = $foreman_proxy::params::dhcp_key_secret,
  $dns                   = $foreman_proxy::params::dns,
  $dns_managed           = $foreman_proxy::params::dns_managed,
  $dns_provider          = $foreman_proxy::params::dns_provider,
  $dns_interface         = $foreman_proxy::params::dns_interface,
  $dns_zone              = $foreman_proxy::params::dns_zone,
  $dns_reverse           = $foreman_proxy::params::dns_reverse,
  $dns_server            = $foreman_proxy::params::dns_server,
  $dns_ttl               = $foreman_proxy::params::dns_ttl,
  $dns_tsig_keytab       = $foreman_proxy::params::dns_tsig_keytab,
  $dns_tsig_principal    = $foreman_proxy::params::dns_tsig_principal,
  $dns_forwarders        = $foreman_proxy::params::dns_forwarders,
  $virsh_network         = $foreman_proxy::params::virsh_network,
  $bmc                   = $foreman_proxy::params::bmc,
  $bmc_default_provider  = $foreman_proxy::params::bmc_default_provider,
  $realm                 = $foreman_proxy::params::realm,
  $realm_provider        = $foreman_proxy::params::realm_provider,
  $realm_keytab          = $foreman_proxy::params::realm_keytab,
  $realm_principal       = $foreman_proxy::params::realm_principal,
  $freeipa_remove_dns    = $foreman_proxy::params::freeipa_remove_dns,
  $keyfile               = $foreman_proxy::params::keyfile,
  $register_in_foreman   = $foreman_proxy::params::register_in_foreman,
  $foreman_base_url      = $foreman_proxy::params::foreman_base_url,
  $registered_name       = $foreman_proxy::params::registered_name,
  $registered_proxy_url  = $foreman_proxy::params::registered_proxy_url,
  $oauth_effective_user  = $foreman_proxy::params::oauth_effective_user,
  $oauth_consumer_key    = $foreman_proxy::params::oauth_consumer_key,
  $oauth_consumer_secret = $foreman_proxy::params::oauth_consumer_secret,
  $pulp                  = $foreman_proxy::params::pulp,
) inherits foreman_proxy::params {

  # Validate misc params
  validate_bool($ssl, $manage_sudoersd, $use_sudoersd, $register_in_foreman, $pulp)
  validate_array($trusted_hosts)

  # Validate puppet params
  validate_bool($puppetca, $puppetrun)
  validate_string($ssldir, $puppetdir, $autosign_location, $puppetca_cmd, $puppetrun_cmd)

  # Validate tftp params
  validate_bool($tftp)
  validate_string($tftp_servername)

  # Validate dhcp params
  validate_bool($dhcp, $dhcp_managed)

  # Validate dns params
  validate_bool($dns)
  validate_string($dns_interface, $dns_provider, $dns_reverse, $dns_server, $keyfile)
  validate_array($dns_forwarders)

  # Validate bmc params
  validate_bool($bmc)
  validate_re($bmc_default_provider, '^(freeipmi|ipmitool|shell)$')

  # Validate realm params
  validate_bool($realm, $freeipa_remove_dns)
  validate_string($realm_provider, $realm_principal)
  validate_absolute_path($realm_keytab)

  class { 'foreman_proxy::install': } ~>
  class { 'foreman_proxy::config': } ~>
  class { 'foreman_proxy::service': } ~>
  class { 'foreman_proxy::register': } ->
  Class['foreman_proxy']
}
