# Install, configure and run a foreman proxy
#
# === Parameters:
#
# $repo::                       This can be stable, rc, or nightly
#                               type:String
#
# $gpgcheck::                   Turn on/off gpg check in repo files (effective only on RedHat family systems)
#                               type:Boolean
#
# $custom_repo::                No need to change anything here by default
#                               if set to true, no repo will be added by this module, letting you to
#                               set it to some custom location.
#                               type:Boolean
#
# $version::                    foreman package version, it's passed to ensure parameter of package resource
#                               can be set to specific version number, 'latest', 'present' etc.
#                               type:String
#
# $ensure_packages_version::    control extra packages version, it's passed to ensure parameter of package resource
#                               type:Enum['latest', 'present', 'installed', 'absent']
#
# $plugin_version::             foreman plugins version, it's passed to ensure parameter of plugins package resource
#                               type:Enum['latest', 'present', 'installed', 'absent']
#
# $bind_host::                  Host to bind ports to, e.g. *, localhost, 0.0.0.0
#                               type:Variant[Array[String], String]
#
# $http::                       Enable HTTP
#                               type:Boolean
#
# $http_port::                  HTTP port to listen on (if http is enabled)
#                               type:Integer[0, 65535]
#
# $ssl::                        Enable SSL, ensure feature is added with "https://" protocol if true
#                               type:Boolean
#
# $ssl_port::                   HTTPS port to listen on (if ssl is enabled)
#                               type:Integer[0, 65535]
#
# $dir::                        Foreman proxy install directory
#                               type:Stdlib::Absolutepath
#
# $user::                       User under which foreman proxy will run
#                               type:String
#
# $groups::                     Array of additional groups for the foreman proxy user
#                               type:Array[String]
#
# $log::                        Foreman proxy log file, 'STDOUT' or 'SYSLOG'
#                               type:Variant[Enum['STDOUT', 'SYSLOG'], Stdlib::Absolutepath]
#
# $log_level::                  Foreman proxy log level
#                               type:Enum['WARN', 'DEBUG', 'ERROR', 'FATAL', 'INFO', 'UNKNOWN']
#
# $log_buffer::                 Log buffer size
#                               type:Integer[0]
#
# $log_buffer_errors::          Additional log buffer size for errors
#                               type:Integer[0]
#
# $ssl_ca::                     SSL CA to validate the client certificates used to access the proxy
#                               type:Stdlib::Absolutepath
#
# $ssl_cert::                   SSL certificate to be used to run the foreman proxy via https.
#                               type:Stdlib::Absolutepath
#
# $ssl_key::                    Corresponding key to a ssl_cert certificate
#                               type:Stdlib::Absolutepath
#
# $foreman_ssl_ca::             SSL CA used to verify connections when accessing the Foreman API.
#                               When not specified, the ssl_ca is used instead.
#                               type:Optional[Stdlib::Absolutepath]
#
# $foreman_ssl_cert::           SSL client certificate used when accessing the Foreman API
#                               When not specified, the ssl_cert is used instead.
#                               type:Optional[Stdlib::Absolutepath]
#
# $foreman_ssl_key::            Corresponding key to a foreman_ssl_cert certificate
#                               When not specified, the ssl_key is used instead.
#                               type:Optional[Stdlib::Absolutepath]
#
# $ssl_disabled_ciphers::       List of OpenSSL cipher suite names that will be disabled from the default
#                               type:Array[String]
#
# $trusted_hosts::              Only hosts listed will be permitted, empty array to disable authorization
#                               type:Array[String]
#
# $manage_sudoersd::            Whether to manage File['/etc/sudoers.d'] or not.  When reusing this module, this may be
#                               disabled to let a dedicated sudo module manage it instead.
#                               type:Boolean
#
# $use_sudoersd::               Add a file to /etc/sudoers.d (true).
#                               type:Boolean
#
# $use_sudoers::                Add contents to /etc/sudoers (true). This is ignored if $use_sudoersd is true.
#                               type:Boolean
#
# $puppetca::                   Enable Puppet CA feature
#                               type:Boolean
#
# $puppetca_listen_on::         Protocols for the Puppet CA feature to listen on
#                               type:Foreman_proxy::ListenOn
#
# $ssldir::                     Puppet CA SSL directory
#                               type:Stdlib::Absolutepath
#
# $puppetdir::                  Puppet var directory
#                               type:Stdlib::Absolutepath
#
# $puppetca_cmd::               Puppet CA command to be allowed in sudoers
#                               type:String
#
# $puppet_group::               Groups of Foreman proxy user
#                               type:String
#
# $manage_puppet_group::        Whether to ensure the $puppet_group exists.  Also ensures group owner of ssl keys and certs is $puppet_group
#                               Not applicable when ssl is false.
#                               type:Boolean
#
# $puppet::                     Enable Puppet module for environment imports and Puppet runs
#                               type:Boolean
#
# $puppet_listen_on::           Protocols for the Puppet feature to listen on
#                               type:Foreman_proxy::ListenOn
#
# $puppetrun_provider::         Provider for running/kicking Puppet agents
#                               type:Optional[Enum['puppetrun', 'mcollective', 'ssh', 'salt', 'customrun']]
#
# $puppetrun_cmd::              Puppet run/kick command to be allowed in sudoers
#                               type:String
#
# $customrun_cmd::              Puppet customrun command
#                               type:String
#
# $customrun_args::             Puppet customrun command arguments
#                               type:String
#
# $mcollective_user::           The user for puppetrun_provider mcollective
#                               type:String
#
# $puppetssh_sudo::             Whether to use sudo before commands when using puppetrun_provider puppetssh
#                               type:Boolean
#
# $puppetssh_command::          The command used by puppetrun_provider puppetssh
#                               type:String
#
# $puppetssh_user::             The user for puppetrun_provider puppetssh
#                               type:String
#
# $puppetssh_keyfile::          The keyfile for puppetrun_provider puppetssh commands
#                               type:Stdlib::Absolutepath
#
# $puppetssh_wait::             Whether to wait for completion of the Puppet command over SSH and return
#                               the exit code
#                               type:Boolean
#
# $salt_puppetrun_cmd::         Salt command to trigger Puppet run
#                               type:String
#
# $puppet_user::                Which user to invoke sudo as to run puppet commands
#                               type:String
#
# $puppet_url::                 URL of the Puppet master itself for API requests
#                               type:Stdlib::HTTPUrl
#
# $puppet_ssl_ca::              SSL CA used to verify connections when accessing the Puppet master API
#                               type:Stdlib::Absolutepath
#
# $puppet_ssl_cert::            SSL certificate used when accessing the Puppet master API
#                               type:Stdlib::Absolutepath
#
# $puppet_ssl_key::             SSL private key used when accessing the Puppet master API
#                               type:Stdlib::Absolutepath
#
# $puppet_use_environment_api:: Override use of Puppet's API to list environments.  When unset, the proxy will
#                               try to determine this automatically.
#                               type:Optional[Boolean]
#
# $puppet_api_timeout::         Timeout in seconds when accessing Puppet environment classes API
#                               type:Integer[0]
#
# $templates::                  Enable templates feature
#                               type:Boolean
#
# $templates_listen_on::        Templates proxy to listen on https, http, or both
#                               type:Foreman_proxy::ListenOn
#
# $template_url::               URL a client should use for provisioning templates
#                               type:Stdlib::HTTPUrl
#
# $logs::                       Enable Logs (log buffer) feature
#                               type:Boolean
#
# $logs_listen_on::             Logs proxy to listen on https, http, or both
#                               type:Foreman_proxy::ListenOn
#
# $tftp::                       Enable TFTP feature
#                               type:Boolean
#
# $tftp_listen_on::             TFTP proxy to listen on https, http, or both
#                               type:Foreman_proxy::ListenOn
#
# $tftp_managed::               TFTP is managed by Foreman proxy
#                               type:Boolean
#
# $tftp_manage_wget::           If enabled will install the wget package
#                               type:Boolean
#
# $tftp_syslinux_filenames::    Syslinux files to install on TFTP (full paths)
#                               type:Array[Stdlib::Absolutepath]
#
# $tftp_root::                  TFTP root directory
#                               type:Stdlib::Absolutepath
#
# $tftp_dirs::                  Directories to be create in $tftp_root
#                               type:Array[Stdlib::Absolutepath]
#
# $tftp_servername::            Defines the TFTP Servername to use, overrides the name in the subnet declaration
#                               type:Optional[String]
#
# $dhcp::                       Enable DHCP feature
#                               type:Boolean
#
# $dhcp_listen_on::             DHCP proxy to listen on https, http, or both
#                               type:Foreman_proxy::ListenOn
#
# $dhcp_managed::               DHCP is managed by Foreman proxy
#                               type:Boolean
#
# $dhcp_provider::              DHCP provider
#                               type:String
#
# $dhcp_subnets::               Subnets list to restrict DHCP management to
#                               type:Array[String]
#
# $dhcp_option_domain::         DHCP use the dhcpd config option domain-name
#                               type:Array[String]
#
# $dhcp_search_domains::        DHCP search domains option
#                               type:Optional[Array[String]]
#
# $dhcp_interface::             DHCP listen interface
#                               type:String
#
# $dhcp_gateway::               DHCP pool gateway
#                               type:Optional[String]
#
# $dhcp_range::                 Space-separated DHCP pool range
#                               type:Optional[String]
#
# $dhcp_nameservers::           DHCP nameservers, comma-separated
#                               type:String
#
# $dhcp_pxeserver::             DHCP "next-server" value, defaults otherwise to IP of dhcp_interface
#                               type:Optional[String]
#
# $dhcp_server::                Address of DHCP server to manage
#                               type:String
#
# $dhcp_config::                DHCP config file path
#                               type:Stdlib::Absolutepath
#
# $dhcp_leases::                DHCP leases file
#                               type:Stdlib::Absolutepath
#
# $dhcp_key_name::              DHCP key name
#                               type:Optional[String]
#
# $dhcp_key_secret::            DHCP password
#                               type:Optional[String]
#
# $dhcp_omapi_port::            DHCP server OMAPI port
#                               type:Integer[0, 65535]
#
# $dns::                        Enable DNS feature
#                               type:Boolean
#
# $dns_listen_on::              DNS proxy to listen on https, http, or both
#                               type:Foreman_proxy::ListenOn
#
# $dns_managed::                DNS is managed by Foreman proxy
#                               type:Boolean
#
# $dns_provider::               DNS provider
#                               type:String
#
# $dns_interface::              DNS interface
#                               type:String
#
# $dns_zone::                   DNS zone name
#                               type:String
#
# $dns_reverse::                DNS reverse zone name
#                               type:Optional[Variant[String, Array[String]]]
#
# $dns_server::                 Address of DNS server to manage
#                               type:String
#
# $dns_ttl::                    DNS default TTL override
#                               type:Integer[0]
#
# $dns_tsig_keytab::            Kerberos keytab for DNS updates using GSS-TSIG authentication
#                               type:String
#
# $dns_tsig_principal::         Kerberos principal for DNS updates using GSS-TSIG authentication
#                               type:String
#
# $dns_forwarders::             DNS forwarders
#                               type:Array[String]
#
# $libvirt_connection::         Connection string of libvirt DNS/DHCP provider (e.g. "qemu:///system")
#                               type:String
#
# $libvirt_network::            Network for libvirt DNS/DHCP provider
#                               type:String
#
# $bmc::                        Enable BMC feature
#                               type:Boolean
#
# $bmc_listen_on::              BMC proxy to listen on https, http, or both
#                               type:Foreman_proxy::ListenOn
#
# $bmc_default_provider::       BMC default provider.
#                               type:Enum['ipmitool', 'freeipmi', 'shell']
#
# $keyfile::                    DNS server keyfile path
#                               type:Stdlib::Absolutepath
#
# $realm::                      Enable realm management feature
#                               type:Boolean
#
# $realm_split_config_files::   Split realm configuration files. This is needed since version 1.15.
#                               type:Boolean
#
# $realm_listen_on::            Realm proxy to listen on https, http, or both
#                               type:Foreman_proxy::ListenOn
#
# $realm_provider::             Realm management provider
#                               type:String
#
# $realm_keytab::               Kerberos keytab path to authenticate realm updates
#                               type:Stdlib::Absolutepath
#
# $realm_principal::            Kerberos principal for realm updates
#                               type:String
#
# $freeipa_config::             Path to FreeIPA default.conf configuration file
#                               type:Stdlib::Absolutepath
#
# $freeipa_remove_dns::         Remove DNS entries from FreeIPA when deleting hosts from realm
#                               type:Boolean
#
# $register_in_foreman::        Register proxy back in Foreman
#                               type:Boolean
#
# $registered_name::            Proxy name which is registered in Foreman
#                               type:String
#
# $registered_proxy_url::       Proxy URL which is registered in Foreman
#                               type:Optional[Stdlib::HTTPUrl]
#
# $foreman_base_url::           Base Foreman URL used for REST interaction
#                               type:Stdlib::HTTPUrl
#
# $oauth_effective_user::       User to be used for REST interaction
#                               type:String
#
# $oauth_consumer_key::         OAuth key to be used for REST interaction
#                               type:String
#
# $oauth_consumer_secret::      OAuth secret to be used for REST interaction
#                               type:String
#
# $puppet_use_cache::           Whether to enable caching of puppet classes
#                               type:Optional[Boolean]
#
class foreman_proxy (
  String $repo                                                                                = $foreman_proxy::params::repo,
  Boolean $gpgcheck                                                                           = $foreman_proxy::params::gpgcheck,
  Boolean $custom_repo                                                                        = $foreman_proxy::params::custom_repo,
  String $version                                                                             = $foreman_proxy::params::version,
  Enum['latest', 'present', 'installed', 'absent'] $ensure_packages_version                   = $foreman_proxy::params::ensure_packages_version,
  Enum['latest', 'present', 'installed', 'absent'] $plugin_version                            = $foreman_proxy::params::plugin_version,
  Variant[Array[String], String] $bind_host                                                   = $foreman_proxy::params::bind_host,
  Integer[0, 65535] $http_port                                                                = $foreman_proxy::params::http_port,
  Integer[0, 65535] $ssl_port                                                                 = $foreman_proxy::params::ssl_port,
  Stdlib::Absolutepath $dir                                                                   = $foreman_proxy::params::dir,
  String $user                                                                                = $foreman_proxy::params::user,
  Array[String] $groups                                                                       = $foreman_proxy::params::groups,
  Variant[Enum['STDOUT', 'SYSLOG'], Stdlib::Absolutepath] $log                                = $foreman_proxy::params::log,
  Enum['WARN', 'DEBUG', 'ERROR', 'FATAL', 'INFO', 'UNKNOWN'] $log_level                       = $foreman_proxy::params::log_level,
  Integer[0] $log_buffer                                                                      = $foreman_proxy::params::log_buffer,
  Integer[0] $log_buffer_errors                                                               = $foreman_proxy::params::log_buffer_errors,
  Boolean $http                                                                               = $foreman_proxy::params::http,
  Boolean $ssl                                                                                = $foreman_proxy::params::ssl,
  Stdlib::Absolutepath $ssl_ca                                                                = $foreman_proxy::params::ssl_ca,
  Stdlib::Absolutepath $ssl_cert                                                              = $foreman_proxy::params::ssl_cert,
  Stdlib::Absolutepath $ssl_key                                                               = $foreman_proxy::params::ssl_key,
  Optional[Stdlib::Absolutepath] $foreman_ssl_ca                                              = $foreman_proxy::params::foreman_ssl_ca,
  Optional[Stdlib::Absolutepath] $foreman_ssl_cert                                            = $foreman_proxy::params::foreman_ssl_cert,
  Optional[Stdlib::Absolutepath] $foreman_ssl_key                                             = $foreman_proxy::params::foreman_ssl_key,
  Array[String] $trusted_hosts                                                                = $foreman_proxy::params::trusted_hosts,
  Array[String] $ssl_disabled_ciphers                                                         = $foreman_proxy::params::ssl_disabled_ciphers,
  Boolean $manage_sudoersd                                                                    = $foreman_proxy::params::manage_sudoersd,
  Boolean $use_sudoersd                                                                       = $foreman_proxy::params::use_sudoersd,
  Boolean $use_sudoers                                                                        = $foreman_proxy::params::use_sudoers,
  Boolean $puppetca                                                                           = $foreman_proxy::params::puppetca,
  Foreman_proxy::ListenOn $puppetca_listen_on                                                 = $foreman_proxy::params::puppetca_listen_on,
  Stdlib::Absolutepath $ssldir                                                                = $foreman_proxy::params::ssldir,
  Stdlib::Absolutepath $puppetdir                                                             = $foreman_proxy::params::puppetdir,
  String $puppetca_cmd                                                                        = $foreman_proxy::params::puppetca_cmd,
  String $puppet_group                                                                        = $foreman_proxy::params::puppet_group,
  Boolean $manage_puppet_group                                                                = $foreman_proxy::params::manage_puppet_group,
  Boolean $puppet                                                                             = $foreman_proxy::params::puppet,
  Foreman_proxy::ListenOn $puppet_listen_on                                                   = $foreman_proxy::params::puppet_listen_on,
  $puppetrun_cmd                                                                              = $foreman_proxy::params::puppetrun_cmd,
  Optional[Enum['puppetrun', 'mcollective', 'ssh', 'salt', 'customrun']] $puppetrun_provider  = $foreman_proxy::params::puppetrun_provider,
  String $customrun_cmd                                                                       = $foreman_proxy::params::customrun_cmd,
  String $customrun_args                                                                      = $foreman_proxy::params::customrun_args,
  String $mcollective_user                                                                    = $foreman_proxy::params::mcollective_user,
  Boolean $puppetssh_sudo                                                                     = $foreman_proxy::params::puppetssh_sudo,
  String $puppetssh_command                                                                   = $foreman_proxy::params::puppetssh_command,
  String $puppetssh_user                                                                      = $foreman_proxy::params::puppetssh_user,
  Stdlib::Absolutepath $puppetssh_keyfile                                                     = $foreman_proxy::params::puppetssh_keyfile,
  Boolean $puppetssh_wait                                                                     = $foreman_proxy::params::puppetssh_wait,
  String $salt_puppetrun_cmd                                                                  = $foreman_proxy::params::salt_puppetrun_cmd,
  String $puppet_user                                                                         = $foreman_proxy::params::puppet_user,
  Stdlib::HTTPUrl $puppet_url                                                                 = $foreman_proxy::params::puppet_url,
  Stdlib::Absolutepath $puppet_ssl_ca                                                         = $foreman_proxy::params::ssl_ca,
  Stdlib::Absolutepath $puppet_ssl_cert                                                       = $foreman_proxy::params::ssl_cert,
  Stdlib::Absolutepath $puppet_ssl_key                                                        = $foreman_proxy::params::ssl_key,
  Optional[Boolean] $puppet_use_environment_api                                               = $foreman_proxy::params::puppet_use_environment_api,
  Integer[0] $puppet_api_timeout                                                              = $foreman_proxy::params::puppet_api_timeout,
  Boolean $templates                                                                          = $foreman_proxy::params::templates,
  Foreman_proxy::ListenOn $templates_listen_on                                                = $foreman_proxy::params::templates_listen_on,
  Stdlib::HTTPUrl $template_url                                                               = $foreman_proxy::params::template_url,
  Boolean $logs                                                                               = $foreman_proxy::params::logs,
  Foreman_proxy::ListenOn $logs_listen_on                                                     = $foreman_proxy::params::logs_listen_on,
  Boolean $tftp                                                                               = $foreman_proxy::params::tftp,
  Foreman_proxy::ListenOn $tftp_listen_on                                                     = $foreman_proxy::params::tftp_listen_on,
  Boolean $tftp_managed                                                                       = $foreman_proxy::params::tftp_managed,
  Boolean $tftp_manage_wget                                                                   = $foreman_proxy::params::tftp_manage_wget,
  Array[Stdlib::Absolutepath] $tftp_syslinux_filenames                                        = $foreman_proxy::params::tftp_syslinux_filenames,
  Stdlib::Absolutepath $tftp_root                                                             = $foreman_proxy::params::tftp_root,
  Array[Stdlib::Absolutepath] $tftp_dirs                                                      = $foreman_proxy::params::tftp_dirs,
  Optional[String] $tftp_servername                                                           = $foreman_proxy::params::tftp_servername,
  Boolean $dhcp                                                                               = $foreman_proxy::params::dhcp,
  Foreman_proxy::ListenOn $dhcp_listen_on                                                     = $foreman_proxy::params::dhcp_listen_on,
  Boolean $dhcp_managed                                                                       = $foreman_proxy::params::dhcp_managed,
  String $dhcp_provider                                                                       = $foreman_proxy::params::dhcp_provider,
  Array[String] $dhcp_subnets                                                                 = $foreman_proxy::params::dhcp_subnets,
  Array[String] $dhcp_option_domain                                                           = $foreman_proxy::params::dhcp_option_domain,
  Optional[Array[String]] $dhcp_search_domains                                                = $foreman_proxy::params::dhcp_search_domains,
  String $dhcp_interface                                                                      = $foreman_proxy::params::dhcp_interface,
  Optional[String] $dhcp_gateway                                                              = $foreman_proxy::params::dhcp_gateway,
  Optional[String] $dhcp_range                                                                = $foreman_proxy::params::dhcp_range,
  Optional[String] $dhcp_pxeserver                                                            = $foreman_proxy::params::dhcp_pxeserver,
  String $dhcp_nameservers                                                                    = $foreman_proxy::params::dhcp_nameservers,
  String $dhcp_server                                                                         = $foreman_proxy::params::dhcp_server,
  Stdlib::Absolutepath $dhcp_config                                                           = $foreman_proxy::params::dhcp_config,
  Stdlib::Absolutepath $dhcp_leases                                                           = $foreman_proxy::params::dhcp_leases,
  Optional[String] $dhcp_key_name                                                             = $foreman_proxy::params::dhcp_key_name,
  Optional[String] $dhcp_key_secret                                                           = $foreman_proxy::params::dhcp_key_secret,
  Integer[0, 65535] $dhcp_omapi_port                                                          = $foreman_proxy::params::dhcp_omapi_port,
  Boolean $dns                                                                                = $foreman_proxy::params::dns,
  Foreman_proxy::ListenOn $dns_listen_on                                                      = $foreman_proxy::params::dns_listen_on,
  Boolean $dns_managed                                                                        = $foreman_proxy::params::dns_managed,
  String $dns_provider                                                                        = $foreman_proxy::params::dns_provider,
  String $dns_interface                                                                       = $foreman_proxy::params::dns_interface,
  String $dns_zone                                                                            = $foreman_proxy::params::dns_zone,
  Optional[Variant[String, Array[String]]] $dns_reverse                                       = $foreman_proxy::params::dns_reverse,
  String $dns_server                                                                          = $foreman_proxy::params::dns_server,
  Integer[0] $dns_ttl                                                                         = $foreman_proxy::params::dns_ttl,
  String $dns_tsig_keytab                                                                     = $foreman_proxy::params::dns_tsig_keytab,
  String $dns_tsig_principal                                                                  = $foreman_proxy::params::dns_tsig_principal,
  Array[String] $dns_forwarders                                                               = $foreman_proxy::params::dns_forwarders,
  String $libvirt_network                                                                     = $foreman_proxy::params::libvirt_network,
  String $libvirt_connection                                                                  = $foreman_proxy::params::libvirt_connection,
  Boolean $bmc                                                                                = $foreman_proxy::params::bmc,
  Foreman_proxy::ListenOn $bmc_listen_on                                                      = $foreman_proxy::params::bmc_listen_on,
  Enum['ipmitool', 'freeipmi', 'shell'] $bmc_default_provider                                 = $foreman_proxy::params::bmc_default_provider,
  Boolean $realm                                                                              = $foreman_proxy::params::realm,
  Boolean $realm_split_config_files                                                           = $foreman_proxy::params::realm_split_config_files,
  Foreman_proxy::ListenOn $realm_listen_on                                                    = $foreman_proxy::params::realm_listen_on,
  String $realm_provider                                                                      = $foreman_proxy::params::realm_provider,
  Stdlib::Absolutepath $realm_keytab                                                          = $foreman_proxy::params::realm_keytab,
  String $realm_principal                                                                     = $foreman_proxy::params::realm_principal,
  Stdlib::Absolutepath $freeipa_config                                                        = $foreman_proxy::params::freeipa_config,
  Boolean $freeipa_remove_dns                                                                 = $foreman_proxy::params::freeipa_remove_dns,
  Stdlib::Absolutepath $keyfile                                                               = $foreman_proxy::params::keyfile,
  Boolean $register_in_foreman                                                                = $foreman_proxy::params::register_in_foreman,
  Stdlib::HTTPUrl $foreman_base_url                                                           = $foreman_proxy::params::foreman_base_url,
  String $registered_name                                                                     = $foreman_proxy::params::registered_name,
  Optional[Stdlib::HTTPUrl] $registered_proxy_url                                             = $foreman_proxy::params::registered_proxy_url,
  String $oauth_effective_user                                                                = $foreman_proxy::params::oauth_effective_user,
  String $oauth_consumer_key                                                                  = $foreman_proxy::params::oauth_consumer_key,
  String $oauth_consumer_secret                                                               = $foreman_proxy::params::oauth_consumer_secret,
  Optional[Boolean] $puppet_use_cache                                                         = $foreman_proxy::params::puppet_use_cache,
) inherits foreman_proxy::params {

  $real_registered_proxy_url = pick($registered_proxy_url, "https://${::fqdn}:${ssl_port}")

  # lint:ignore:spaceship_operator_without_tag
  class { '::foreman_proxy::install': }
  ~> class { '::foreman_proxy::config': }
  ~> Foreman_proxy::Plugin <| |>
  ~> class { '::foreman_proxy::service': }
  ~> class { '::foreman_proxy::register': }
  -> Class['foreman_proxy']
  # lint:endignore
}
