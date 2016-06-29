# Install, configure and run a foreman proxy
#
# === Parameters:
#
# $repo::                       This can be stable, rc, or nightly
#
# $gpgcheck::                   Turn on/off gpg check in repo files (effective only on RedHat family systems)
#                               type:boolean
#
# $custom_repo::                No need to change anything here by default
#                               if set to true, no repo will be added by this module, letting you to
#                               set it to some custom location.
#                               type:boolean
#
# $version::                    foreman package version, it's passed to ensure parameter of package resource
#                               can be set to specific version number, 'latest', 'present' etc.
#
# $ensure_packages_version::    control extra packages version, it's passed to ensure parameter of package resource
#                               can be set to 'installed', 'present', 'latest', 'absent'
#
# $plugin_version::             foreman plugins version, it's passed to ensure parameter of plugins package resource
#                               can be set to 'latest', 'present',  'installed', 'absent'.
#
# $bind_host::                  Host to bind ports to, e.g. *, localhost, 0.0.0.0
#
# $http::                       Enable HTTP
#                               type:boolean
#
# $http_port::                  HTTP port to listen on (if http is enabled)
#                               type:integer
#
# $ssl::                        Enable SSL, ensure feature is added with "https://" protocol if true
#                               type:boolean
#
# $ssl_port::                   HTTPS port to listen on (if ssl is enabled)
#                               type:integer
#
# $dir::                        Foreman proxy install directory
#
# $user::                       User under which foreman proxy will run
#
# $log::                        Foreman proxy log file, 'STDOUT' or 'SYSLOG'
#
# $log_level::                  Foreman proxy log level: WARN, DEBUG, ERROR, FATAL, INFO, UNKNOWN
#
# $log_buffer::                 Log buffer size
#                               type:integer
#
# $log_buffer_errors::          Additional log buffer size for errors
#                               type:integer
#
# $ssl_ca::                     SSL CA to validate the client certificates used to access the proxy
#
# $ssl_cert::                   SSL certificate to be used to run the foreman proxy via https.
#
# $ssl_key::                    Corresponding key to a ssl_cert certificate
#
# $foreman_ssl_ca::             SSL CA used to verify connections when accessing the Foreman API.
#                               When not specified, the ssl_ca is used instead.
#
# $foreman_ssl_cert::           SSL client certificate used when accessing the Foreman API
#                               When not specified, the ssl_cert is used instead.
#
# $foreman_ssl_key::            Corresponding key to a foreman_ssl_cert certificate
#                               When not specified, the ssl_key is used instead.
#
# $ssl_disabled_ciphers::       List of OpenSSL cipher suite names that will be disabled from the default
#                               type:array
#
# $trusted_hosts::              Only hosts listed will be permitted, empty array to disable authorization
#                               type:array
#
# $manage_sudoersd::            Whether to manage File['/etc/sudoers.d'] or not.  When reusing this module, this may be
#                               disabled to let a dedicated sudo module manage it instead.
#                               type:boolean
#
# $use_sudoersd::               Add a file to /etc/sudoers.d (true) or uses augeas (false)
#                               type:boolean
#
# $puppetca::                   Enable Puppet CA feature
#                               type:boolean
#
# $puppetca_listen_on::         Puppet CA feature to listen on https, http, or both
#
# $ssldir::                     Puppet CA ssl directory
#
# $puppetdir::                  Puppet var directory
#
# $puppetca_cmd::               Puppet CA command to be allowed in sudoers
#
# $puppet_group::               Groups of Foreman proxy user
#
# $manage_puppet_group::        Whether to ensure the $puppet_group exists.  Also ensures group owner of ssl keys and certs is $puppet_group
#                               Not applicable when ssl is false.
#                               type:boolean
#
# $puppet::                     Enable Puppet module for environment imports and Puppet runs
#                               type:boolean
#
# $puppet_listen_on::           Puppet feature to listen on https, http, or both
#
# $puppetrun_provider::         Provider for running/kicking Puppet agents
#
# $puppetrun_cmd::              Puppet run/kick command to be allowed in sudoers
#
# $customrun_cmd::              Puppet customrun command
#
# $customrun_args::             Puppet customrun command arguments
#
# $mcollective_user::           The user for puppetrun_provider mcollective
#
# $puppetssh_sudo::             Whether to use sudo before commands when using puppetrun_provider puppetssh
#                               type:boolean
#
# $puppetssh_command::          The command used by puppetrun_provider puppetssh
#
# $puppetssh_user::             The user for puppetrun_provider puppetssh
#
# $puppetssh_keyfile::          The keyfile for puppetrun_provider puppetssh commands
#
# $puppetssh_wait::             Whether to wait for completion of the Puppet command over SSH and return
#                               the exit code
#                               type:boolean
#
# $salt_puppetrun_cmd::         Salt command to trigger Puppet run
#
# $puppet_user::                Which user to invoke sudo as to run puppet commands
#
# $puppet_url::                 URL of the Puppet master itself for API requests
#
# $puppet_ssl_ca::              SSL CA used to verify connections when accessing the Puppet master API
#
# $puppet_ssl_cert::            SSL certificate used when accessing the Puppet master API
#
# $puppet_ssl_key::             SSL private key used when accessing the Puppet master API
#
# $puppet_use_environment_api:: Override use of Puppet's API to list environments.  When unset, the proxy will
#                               try to determine this automatically.
#                               type:boolean
#
# $templates::                  Enable templates feature
#                               type:boolean
#
# $templates_listen_on::        Templates proxy to listen on https, http, or both
#
# $template_url::               URL a client should use for provisioning templates
#
# $logs::                       Enable Logs (log buffer) feature
#                               type:boolean
#
# $logs_listen_on::             Logs proxy to listen on https, http, or both
#
# $tftp::                       Enable TFTP feature
#                               type:boolean
#
# $tftp_listen_on::             TFTP proxy to listen on https, http, or both
#
# $tftp_managed::               TFTP is managed by Foreman proxy
#                               type:boolean
#
# $tftp_manage_wget::           If enabled will install the wget package
#                               type:boolean
#
# $tftp_syslinux_filenames::    Syslinux files to install on TFTP (full paths)
#                               type:array
#
# $tftp_root::                  TFTP root directory
#
# $tftp_dirs::                  Directories to be create in $tftp_root
#                               type:array
#
# $tftp_servername::            Defines the TFTP Servername to use, overrides the name in the subnet declaration
#
# $dhcp::                       Enable DHCP feature
#                               type:boolean
#
# $dhcp_listen_on::             DHCP proxy to listen on https, http, or both
#
# $dhcp_managed::               DHCP is managed by Foreman proxy
#                               type:boolean
#
# $dhcp_provider::              DHCP provider
#
# $dhcp_subnets::               Subnets list to restrict DHCP management to
#                               type:array
#
# $dhcp_option_domain::         DHCP use the dhcpd config option domain-name
#                               type:array
#
# $dhcp_search_domains::        DHCP search domains option
#                               type:array
#
# $dhcp_interface::             DHCP listen interface
#
# $dhcp_gateway::               DHCP pool gateway
#
# $dhcp_range::                 Space-separated DHCP pool range
#
# $dhcp_nameservers::           DHCP nameservers
#
# $dhcp_server::                Address of DHCP server to manage
#
# $dhcp_config::                DHCP config file path
#
# $dhcp_leases::                DHCP leases file
#
# $dhcp_key_name::              DHCP key name
#
# $dhcp_key_secret::            DHCP password
#
# $dhcp_omapi_port::            DHCP server OMAPI port
#                               type:integer
#
# $dns::                        Enable DNS feature
#                               type:boolean
#
# $dns_listen_on::              DNS proxy to listen on https, http, or both
#
# $dns_managed::                DNS is managed by Foreman proxy
#                               type:boolean
#
# $dns_provider::               DNS provider
#
# $dns_interface::              DNS interface
#
# $dns_zone::                   DNS zone name
#
# $dns_reverse::                DNS reverse zone name
#
# $dns_server::                 Address of DNS server to manage
#
# $dns_ttl::                    DNS default TTL override
#
# $dns_tsig_keytab::            Kerberos keytab for DNS updates using GSS-TSIG authentication
#
# $dns_tsig_principal::         Kerberos principal for DNS updates using GSS-TSIG authentication
#
# $dns_forwarders::             DNS forwarders
#                               type:array
#
# $libvirt_connection::         Connection string of libvirt DNS/DHCP provider (e.g. "qemu:///system")
#
# $libvirt_network::            Network for libvirt DNS/DHCP provider
#
# $bmc::                        Enable BMC feature
#                               type:boolean
#
# $bmc_listen_on::              BMC proxy to listen on https, http, or both
#
# $bmc_default_provider::       BMC default provider.
#
# $keyfile::                    DNS server keyfile path
#
# $realm::                      Enable realm management feature
#                               type:boolean
#
# $realm_listen_on::            Realm proxy to listen on https, http, or both
#
# $realm_provider::             Realm management provider
#
# $realm_keytab::               Kerberos keytab path to authenticate realm updates
#
# $realm_principal::            Kerberos principal for realm updates
#
# $freeipa_remove_dns::         Remove DNS entries from FreeIPA when deleting hosts from realm
#                               type:boolean
#
# $register_in_foreman::        Register proxy back in Foreman
#                               type:boolean
#
# $registered_name::            Proxy name which is registered in Foreman
#
# $registered_proxy_url::       Proxy URL which is registered in Foreman
#
# $foreman_base_url::           Base Foreman URL used for REST interaction
#
# $oauth_effective_user::       User to be used for REST interaction
#
# $oauth_consumer_key::         OAuth key to be used for REST interaction
#
# $oauth_consumer_secret::      OAuth secret to be used for REST interaction
#
# $puppet_use_cache::           Whether to enable caching of puppet classes
#                               type:boolean
#
class foreman_proxy (
  $repo                       = $foreman_proxy::params::repo,
  $gpgcheck                   = $foreman_proxy::params::gpgcheck,
  $custom_repo                = $foreman_proxy::params::custom_repo,
  $version                    = $foreman_proxy::params::version,
  $ensure_packages_version    = $foreman_proxy::params::ensure_packages_version,
  $plugin_version             = $foreman_proxy::params::plugin_version,
  $bind_host                  = $foreman_proxy::params::bind_host,
  $http_port                  = $foreman_proxy::params::http_port,
  $ssl_port                   = $foreman_proxy::params::ssl_port,
  $dir                        = $foreman_proxy::params::dir,
  $user                       = $foreman_proxy::params::user,
  $log                        = $foreman_proxy::params::log,
  $log_level                  = $foreman_proxy::params::log_level,
  $log_buffer                 = $foreman_proxy::params::log_buffer,
  $log_buffer_errors          = $foreman_proxy::params::log_buffer_errors,
  $http                       = $foreman_proxy::params::http,
  $ssl                        = $foreman_proxy::params::ssl,
  $ssl_ca                     = $foreman_proxy::params::ssl_ca,
  $ssl_cert                   = $foreman_proxy::params::ssl_cert,
  $ssl_key                    = $foreman_proxy::params::ssl_key,
  $foreman_ssl_ca             = $foreman_proxy::params::foreman_ssl_ca,
  $foreman_ssl_cert           = $foreman_proxy::params::foreman_ssl_cert,
  $foreman_ssl_key            = $foreman_proxy::params::foreman_ssl_key,
  $trusted_hosts              = $foreman_proxy::params::trusted_hosts,
  $ssl_disabled_ciphers       = $foreman_proxy::params::ssl_disabled_ciphers,
  $manage_sudoersd            = $foreman_proxy::params::manage_sudoersd,
  $use_sudoersd               = $foreman_proxy::params::use_sudoersd,
  $puppetca                   = $foreman_proxy::params::puppetca,
  $puppetca_listen_on         = $foreman_proxy::params::puppetca_listen_on,
  $ssldir                     = $foreman_proxy::params::ssldir,
  $puppetdir                  = $foreman_proxy::params::puppetdir,
  $puppetca_cmd               = $foreman_proxy::params::puppetca_cmd,
  $puppet_group               = $foreman_proxy::params::puppet_group,
  $manage_puppet_group        = $foreman_proxy::params::manage_puppet_group,
  $puppet                     = $foreman_proxy::params::puppet,
  $puppet_listen_on           = $foreman_proxy::params::puppet_listen_on,
  $puppetrun_cmd              = $foreman_proxy::params::puppetrun_cmd,
  $puppetrun_provider         = $foreman_proxy::params::puppetrun_provider,
  $customrun_cmd              = $foreman_proxy::params::customrun_cmd,
  $customrun_args             = $foreman_proxy::params::customrun_args,
  $mcollective_user           = $foreman_proxy::params::mcollective_user,
  $puppetssh_sudo             = $foreman_proxy::params::puppetssh_sudo,
  $puppetssh_command          = $foreman_proxy::params::puppetssh_command,
  $puppetssh_user             = $foreman_proxy::params::puppetssh_user,
  $puppetssh_keyfile          = $foreman_proxy::params::puppetssh_keyfile,
  $puppetssh_wait             = $foreman_proxy::params::puppetssh_wait,
  $salt_puppetrun_cmd         = $foreman_proxy::params::salt_puppetrun_cmd,
  $puppet_user                = $foreman_proxy::params::puppet_user,
  $puppet_url                 = $foreman_proxy::params::puppet_url,
  $puppet_ssl_ca              = $foreman_proxy::params::ssl_ca,
  $puppet_ssl_cert            = $foreman_proxy::params::ssl_cert,
  $puppet_ssl_key             = $foreman_proxy::params::ssl_key,
  $puppet_use_environment_api = $foreman_proxy::params::puppet_use_environment_api,
  $templates                  = $foreman_proxy::params::templates,
  $templates_listen_on        = $foreman_proxy::params::templates_listen_on,
  $template_url               = $foreman_proxy::params::template_url,
  $logs                       = $foreman_proxy::params::logs,
  $logs_listen_on             = $foreman_proxy::params::logs_listen_on,
  $tftp                       = $foreman_proxy::params::tftp,
  $tftp_listen_on             = $foreman_proxy::params::tftp_listen_on,
  $tftp_managed               = $foreman_proxy::params::tftp_managed,
  $tftp_manage_wget           = $foreman_proxy::params::tftp_manage_wget,
  $tftp_syslinux_filenames    = $foreman_proxy::params::tftp_syslinux_filenames,
  $tftp_root                  = $foreman_proxy::params::tftp_root,
  $tftp_dirs                  = $foreman_proxy::params::tftp_dirs,
  $tftp_servername            = $foreman_proxy::params::tftp_servername,
  $dhcp                       = $foreman_proxy::params::dhcp,
  $dhcp_listen_on             = $foreman_proxy::params::dhcp_listen_on,
  $dhcp_managed               = $foreman_proxy::params::dhcp_managed,
  $dhcp_provider              = $foreman_proxy::params::dhcp_provider,
  $dhcp_subnets               = $foreman_proxy::params::dhcp_subnets,
  $dhcp_option_domain         = $foreman_proxy::params::dhcp_option_domain,
  $dhcp_search_domains        = $foreman_proxy::params::dhcp_search_domains,
  $dhcp_interface             = $foreman_proxy::params::dhcp_interface,
  $dhcp_gateway               = $foreman_proxy::params::dhcp_gateway,
  $dhcp_range                 = $foreman_proxy::params::dhcp_range,
  $dhcp_nameservers           = $foreman_proxy::params::dhcp_nameservers,
  $dhcp_server                = $foreman_proxy::params::dhcp_server,
  $dhcp_config                = $foreman_proxy::params::dhcp_config,
  $dhcp_leases                = $foreman_proxy::params::dhcp_leases,
  $dhcp_key_name              = $foreman_proxy::params::dhcp_key_name,
  $dhcp_key_secret            = $foreman_proxy::params::dhcp_key_secret,
  $dhcp_omapi_port            = $foreman_proxy::params::dhcp_omapi_port,
  $dns                        = $foreman_proxy::params::dns,
  $dns_listen_on              = $foreman_proxy::params::dns_listen_on,
  $dns_managed                = $foreman_proxy::params::dns_managed,
  $dns_provider               = $foreman_proxy::params::dns_provider,
  $dns_interface              = $foreman_proxy::params::dns_interface,
  $dns_zone                   = $foreman_proxy::params::dns_zone,
  $dns_reverse                = $foreman_proxy::params::dns_reverse,
  $dns_server                 = $foreman_proxy::params::dns_server,
  $dns_ttl                    = $foreman_proxy::params::dns_ttl,
  $dns_tsig_keytab            = $foreman_proxy::params::dns_tsig_keytab,
  $dns_tsig_principal         = $foreman_proxy::params::dns_tsig_principal,
  $dns_forwarders             = $foreman_proxy::params::dns_forwarders,
  $libvirt_network            = $foreman_proxy::params::libvirt_network,
  $libvirt_connection         = $foreman_proxy::params::libvirt_connection,
  $bmc                        = $foreman_proxy::params::bmc,
  $bmc_listen_on              = $foreman_proxy::params::bmc_listen_on,
  $bmc_default_provider       = $foreman_proxy::params::bmc_default_provider,
  $realm                      = $foreman_proxy::params::realm,
  $realm_listen_on            = $foreman_proxy::params::realm_listen_on,
  $realm_provider             = $foreman_proxy::params::realm_provider,
  $realm_keytab               = $foreman_proxy::params::realm_keytab,
  $realm_principal            = $foreman_proxy::params::realm_principal,
  $freeipa_remove_dns         = $foreman_proxy::params::freeipa_remove_dns,
  $keyfile                    = $foreman_proxy::params::keyfile,
  $register_in_foreman        = $foreman_proxy::params::register_in_foreman,
  $foreman_base_url           = $foreman_proxy::params::foreman_base_url,
  $registered_name            = $foreman_proxy::params::registered_name,
  $registered_proxy_url       = $foreman_proxy::params::registered_proxy_url,
  $oauth_effective_user       = $foreman_proxy::params::oauth_effective_user,
  $oauth_consumer_key         = $foreman_proxy::params::oauth_consumer_key,
  $oauth_consumer_secret      = $foreman_proxy::params::oauth_consumer_secret,
  $puppet_use_cache           = $foreman_proxy::params::puppet_use_cache,
) inherits foreman_proxy::params {

  # Validate misc params
  validate_string($bind_host)
  validate_bool($ssl, $manage_sudoersd, $use_sudoersd, $register_in_foreman, $manage_puppet_group)
  validate_array($trusted_hosts, $ssl_disabled_ciphers)
  validate_re($log_level, '^(UNKNOWN|FATAL|ERROR|WARN|INFO|DEBUG)$')
  validate_re($plugin_version, '^(installed|present|latest|absent)$')
  validate_re($ensure_packages_version, '^(installed|present|latest|absent)$')
  # lint:ignore:undef_in_function
  validate_integer($log_buffer, undef, 0)
  validate_integer($log_buffer_errors, undef, 0)
  # lint:endignore

  # Validate puppet params
  validate_bool($puppet, $puppetssh_wait)
  validate_string($ssldir, $puppetdir, $puppetca_cmd, $puppetrun_cmd)
  validate_string($puppet_url, $puppet_ssl_ca, $puppet_ssl_cert, $puppet_ssl_key)
  validate_string($mcollective_user, $salt_puppetrun_cmd)
  if $puppet_use_cache != undef {
    validate_bool($puppet_use_cache)
  }
  if $puppetrun_provider {
    validate_string($puppetrun_provider)
  }

  # Validate template params
  validate_string($template_url)

  # Validate logs params
  validate_bool($logs)
  validate_listen_on($logs_listen_on)

  # Validate tftp params
  validate_bool($tftp_managed, $tftp_manage_wget)
  if $tftp_servername {
    validate_string($tftp_servername)
  }

  # Validate dhcp params
  validate_bool($dhcp_managed)
  validate_array($dhcp_option_domain)
  validate_integer($dhcp_omapi_port)
  validate_string($dhcp_provider, $dhcp_server)
  validate_array($dhcp_subnets)

  # Validate dns params
  validate_bool($dns)
  validate_string($dns_interface, $dns_provider, $dns_reverse, $dns_server, $keyfile)
  validate_array($dns_forwarders)

  # Validate libvirt params
  validate_string($libvirt_network, $libvirt_connection)

  # Validate bmc params
  validate_re($bmc_default_provider, '^(freeipmi|ipmitool|shell)$')

  # Validate realm params
  validate_bool($freeipa_remove_dns)
  validate_string($realm_provider, $realm_principal)
  validate_absolute_path($realm_keytab)

  $real_registered_proxy_url = pick($registered_proxy_url, "https://${::fqdn}:${ssl_port}")

  # lint:ignore:spaceship_operator_without_tag
  class { '::foreman_proxy::install': } ~>
  class { '::foreman_proxy::config': } ~>
  Foreman_proxy::Plugin <| |> ~>
  class { '::foreman_proxy::service': } ~>
  class { '::foreman_proxy::register': } ->
  Class['foreman_proxy']
  # lint:endignore
}
