# Install, configure and run a foreman proxy
#
# === Parameters:
#
# $repo::                       This can be stable, rc, or nightly
#
# $gpgcheck::                   Turn on/off gpg check in repo files (effective only on RedHat family systems)
#
# $custom_repo::                No need to change anything here by default
#                               if set to true, no repo will be added by this module, letting you to
#                               set it to some custom location.
#
# $version::                    foreman package version, it's passed to ensure parameter of package resource
#                               can be set to specific version number, 'latest', 'present' etc.
#
# $ensure_packages_version::    control extra packages version, it's passed to ensure parameter of package resource
#
# $plugin_version::             foreman plugins version, it's passed to ensure parameter of plugins package resource
#
# $bind_host::                  Host to bind ports to, e.g. *, localhost, 0.0.0.0
#
# $http::                       Enable HTTP
#
# $http_port::                  HTTP port to listen on (if http is enabled)
#
# $ssl::                        Enable SSL, ensure feature is added with "https://" protocol if true
#
# $ssl_port::                   HTTPS port to listen on (if ssl is enabled)
#
# $dir::                        Foreman proxy install directory
#
# $user::                       User under which foreman proxy will run
#
# $groups::                     Array of additional groups for the foreman proxy user
#
# $log::                        Foreman proxy log file, 'STDOUT' or 'SYSLOG'
#
# $log_level::                  Foreman proxy log level
#
# $log_buffer::                 Log buffer size
#
# $log_buffer_errors::          Additional log buffer size for errors
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
#
# $trusted_hosts::              Only hosts listed will be permitted, empty array to disable authorization
#
# $manage_sudoersd::            Whether to manage File['/etc/sudoers.d'] or not.  When reusing this module, this may be
#                               disabled to let a dedicated sudo module manage it instead.
#
# $use_sudoersd::               Add a file to /etc/sudoers.d (true).
#
# $use_sudoers::                Add contents to /etc/sudoers (true). This is ignored if $use_sudoersd is true.
#
# $puppetca::                   Enable Puppet CA feature
#
# $puppetca_listen_on::         Protocols for the Puppet CA feature to listen on
#
# $ssldir::                     Puppet CA SSL directory
#
# $puppetdir::                  Puppet var directory
#
# $puppetca_cmd::               Puppet CA command to be allowed in sudoers
#
# $puppet_group::               Groups of Foreman proxy user
#
# $autosignfile::               Path to the autosign file. This is needed since version 1.16.
#
# $use_autosignfile::           Use $autosignfile? This is needed since version 1.16.
#
# $manage_puppet_group::        Whether to ensure the $puppet_group exists.  Also ensures group owner of ssl keys and certs is $puppet_group
#                               Not applicable when ssl is false.
#
# $puppet::                     Enable Puppet module for environment imports and Puppet runs
#
# $puppet_listen_on::           Protocols for the Puppet feature to listen on
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
#
# $puppetssh_command::          The command used by puppetrun_provider puppetssh
#
# $puppetssh_user::             The user for puppetrun_provider puppetssh
#
# $puppetssh_keyfile::          The keyfile for puppetrun_provider puppetssh commands
#
# $puppetssh_wait::             Whether to wait for completion of the Puppet command over SSH and return
#                               the exit code
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
#
# $puppet_api_timeout::         Timeout in seconds when accessing Puppet environment classes API
#
# $templates::                  Enable templates feature
#
# $templates_listen_on::        Templates proxy to listen on https, http, or both
#
# $template_url::               URL a client should use for provisioning templates
#
# $logs::                       Enable Logs (log buffer) feature
#
# $logs_listen_on::             Logs proxy to listen on https, http, or both
#
# $tftp::                       Enable TFTP feature
#
# $tftp_listen_on::             TFTP proxy to listen on https, http, or both
#
# $tftp_managed::               TFTP is managed by Foreman proxy
#
# $tftp_manage_wget::           If enabled will install the wget package
#
# $tftp_syslinux_filenames::    Syslinux files to install on TFTP (full paths)
#
# $tftp_root::                  TFTP root directory
#
# $tftp_dirs::                  Directories to be create in $tftp_root
#
# $tftp_servername::            Defines the TFTP Servername to use, overrides the name in the subnet declaration
#
# $dhcp::                       Enable DHCP feature
#
# $dhcp_listen_on::             DHCP proxy to listen on https, http, or both
#
# $dhcp_managed::               DHCP is managed by Foreman proxy
#
# $dhcp_provider::              DHCP provider
#
# $dhcp_subnets::               Subnets list to restrict DHCP management to
#
# $dhcp_option_domain::         DHCP use the dhcpd config option domain-name
#
# $dhcp_search_domains::        DHCP search domains option
#
# $dhcp_interface::             DHCP listen interface
#
# $dhcp_gateway::               DHCP pool gateway
#
# $dhcp_range::                 Space-separated DHCP pool range
#
# $dhcp_nameservers::           DHCP nameservers, comma-separated
#
# $dhcp_pxeserver::             DHCP "next-server" value, defaults otherwise to IP of dhcp_interface
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
#
# $dhcp_node_type::             DHCP node type
#
# $dhcp_peer_address::          The other DHCP servers address
#
# $dns::                        Enable DNS feature
#
# $dns_listen_on::              DNS proxy to listen on https, http, or both
#
# $dns_managed::                DNS is managed by Foreman proxy
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
#
# $libvirt_connection::         Connection string of libvirt DNS/DHCP provider (e.g. "qemu:///system")
#
# $libvirt_network::            Network for libvirt DNS/DHCP provider
#
# $bmc::                        Enable BMC feature
#
# $bmc_listen_on::              BMC proxy to listen on https, http, or both
#
# $bmc_default_provider::       BMC default provider.
#
# $keyfile::                    DNS server keyfile path
#
# $realm::                      Enable realm management feature
#
# $realm_split_config_files::   Split realm configuration files. This is needed since version 1.15.
#
# $realm_listen_on::            Realm proxy to listen on https, http, or both
#
# $realm_provider::             Realm management provider
#
# $realm_keytab::               Kerberos keytab path to authenticate realm updates
#
# $realm_principal::            Kerberos principal for realm updates
#
# $freeipa_config::             Path to FreeIPA default.conf configuration file
#
# $freeipa_remove_dns::         Remove DNS entries from FreeIPA when deleting hosts from realm
#
# $register_in_foreman::        Register proxy back in Foreman
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
#
# === Advanced parameters:
#
# $dhcp_failover_address::      Address for DHCP to listen for connections from its peer
#
# $dhcp_failover_port::         Port for DHCP to listen & communicate with it DHCP peer
#
# $dhcp_max_response_delay::    Seconds after it will assume that connection has failed to DHCP peer
#
# $dhcp_max_unacked_updates::   How many BNDUPD messages DHCP can send before it receives a BNDACK from the local system
#
# $dhcp_mclt::                  Seconds for which a lease may be renewed by either failover peer without contacting the other
#
# $dhcp_load_split::            Split leases between Primary and Secondary. 255 means Primary is chiefly responsible. 0 means Secondary is chiefly responsible.
#
# $dhcp_load_balance::          Cutoff after which load balancing is disabled
#
class foreman_proxy (
  String $repo = $::foreman_proxy::params::repo,
  Boolean $gpgcheck = $::foreman_proxy::params::gpgcheck,
  Boolean $custom_repo = $::foreman_proxy::params::custom_repo,
  String $version = $::foreman_proxy::params::version,
  Enum['latest', 'present', 'installed', 'absent'] $ensure_packages_version = $::foreman_proxy::params::ensure_packages_version,
  Enum['latest', 'present', 'installed', 'absent'] $plugin_version = $::foreman_proxy::params::plugin_version,
  Variant[Array[String], String] $bind_host = $::foreman_proxy::params::bind_host,
  Integer[0, 65535] $http_port = $::foreman_proxy::params::http_port,
  Integer[0, 65535] $ssl_port = $::foreman_proxy::params::ssl_port,
  Stdlib::Absolutepath $dir = $::foreman_proxy::params::dir,
  String $user = $::foreman_proxy::params::user,
  Array[String] $groups = $::foreman_proxy::params::groups,
  Variant[Enum['STDOUT', 'SYSLOG'], Stdlib::Absolutepath] $log = $::foreman_proxy::params::log,
  Enum['WARN', 'DEBUG', 'ERROR', 'FATAL', 'INFO', 'UNKNOWN'] $log_level = $::foreman_proxy::params::log_level,
  Integer[0] $log_buffer = $::foreman_proxy::params::log_buffer,
  Integer[0] $log_buffer_errors = $::foreman_proxy::params::log_buffer_errors,
  Boolean $http = $::foreman_proxy::params::http,
  Boolean $ssl = $::foreman_proxy::params::ssl,
  Stdlib::Absolutepath $ssl_ca = $::foreman_proxy::params::ssl_ca,
  Stdlib::Absolutepath $ssl_cert = $::foreman_proxy::params::ssl_cert,
  Stdlib::Absolutepath $ssl_key = $::foreman_proxy::params::ssl_key,
  Optional[Stdlib::Absolutepath] $foreman_ssl_ca = $::foreman_proxy::params::foreman_ssl_ca,
  Optional[Stdlib::Absolutepath] $foreman_ssl_cert = $::foreman_proxy::params::foreman_ssl_cert,
  Optional[Stdlib::Absolutepath] $foreman_ssl_key = $::foreman_proxy::params::foreman_ssl_key,
  Array[String] $trusted_hosts = $::foreman_proxy::params::trusted_hosts,
  Array[String] $ssl_disabled_ciphers = $::foreman_proxy::params::ssl_disabled_ciphers,
  Boolean $manage_sudoersd = $::foreman_proxy::params::manage_sudoersd,
  Boolean $use_sudoersd = $::foreman_proxy::params::use_sudoersd,
  Boolean $use_sudoers = $::foreman_proxy::params::use_sudoers,
  Boolean $puppetca = $::foreman_proxy::params::puppetca,
  Foreman_proxy::ListenOn $puppetca_listen_on = $::foreman_proxy::params::puppetca_listen_on,
  Stdlib::Absolutepath $ssldir = $::foreman_proxy::params::ssldir,
  Stdlib::Absolutepath $puppetdir = $::foreman_proxy::params::puppetdir,
  String $puppetca_cmd = $::foreman_proxy::params::puppetca_cmd,
  String $puppet_group = $::foreman_proxy::params::puppet_group,
  Stdlib::Absolutepath $autosignfile = $::foreman_proxy::params::autosignfile,
  Boolean $use_autosignfile = $::foreman_proxy::params::use_autosignfile,
  Boolean $manage_puppet_group = $::foreman_proxy::params::manage_puppet_group,
  Boolean $puppet = $::foreman_proxy::params::puppet,
  Foreman_proxy::ListenOn $puppet_listen_on = $::foreman_proxy::params::puppet_listen_on,
  String $puppetrun_cmd = $::foreman_proxy::params::puppetrun_cmd,
  Optional[Enum['puppetrun', 'mcollective', 'ssh', 'salt', 'customrun']] $puppetrun_provider = $::foreman_proxy::params::puppetrun_provider,
  String $customrun_cmd = $::foreman_proxy::params::customrun_cmd,
  String $customrun_args = $::foreman_proxy::params::customrun_args,
  String $mcollective_user = $::foreman_proxy::params::mcollective_user,
  Boolean $puppetssh_sudo = $::foreman_proxy::params::puppetssh_sudo,
  String $puppetssh_command = $::foreman_proxy::params::puppetssh_command,
  String $puppetssh_user = $::foreman_proxy::params::puppetssh_user,
  Stdlib::Absolutepath $puppetssh_keyfile = $::foreman_proxy::params::puppetssh_keyfile,
  Boolean $puppetssh_wait = $::foreman_proxy::params::puppetssh_wait,
  String $salt_puppetrun_cmd = $::foreman_proxy::params::salt_puppetrun_cmd,
  String $puppet_user = $::foreman_proxy::params::puppet_user,
  Stdlib::HTTPUrl $puppet_url = $::foreman_proxy::params::puppet_url,
  Stdlib::Absolutepath $puppet_ssl_ca = $::foreman_proxy::params::ssl_ca,
  Stdlib::Absolutepath $puppet_ssl_cert = $::foreman_proxy::params::ssl_cert,
  Stdlib::Absolutepath $puppet_ssl_key = $::foreman_proxy::params::ssl_key,
  Optional[Boolean] $puppet_use_environment_api = $::foreman_proxy::params::puppet_use_environment_api,
  Integer[0] $puppet_api_timeout = $::foreman_proxy::params::puppet_api_timeout,
  Boolean $templates = $::foreman_proxy::params::templates,
  Foreman_proxy::ListenOn $templates_listen_on = $::foreman_proxy::params::templates_listen_on,
  Stdlib::HTTPUrl $template_url = $::foreman_proxy::params::template_url,
  Boolean $logs = $::foreman_proxy::params::logs,
  Foreman_proxy::ListenOn $logs_listen_on = $::foreman_proxy::params::logs_listen_on,
  Boolean $tftp = $::foreman_proxy::params::tftp,
  Foreman_proxy::ListenOn $tftp_listen_on = $::foreman_proxy::params::tftp_listen_on,
  Boolean $tftp_managed = $::foreman_proxy::params::tftp_managed,
  Boolean $tftp_manage_wget = $::foreman_proxy::params::tftp_manage_wget,
  Array[Stdlib::Absolutepath] $tftp_syslinux_filenames = $::foreman_proxy::params::tftp_syslinux_filenames,
  Stdlib::Absolutepath $tftp_root = $::foreman_proxy::params::tftp_root,
  Array[Stdlib::Absolutepath] $tftp_dirs = $::foreman_proxy::params::tftp_dirs,
  Optional[String] $tftp_servername = $::foreman_proxy::params::tftp_servername,
  Boolean $dhcp = $::foreman_proxy::params::dhcp,
  Foreman_proxy::ListenOn $dhcp_listen_on = $::foreman_proxy::params::dhcp_listen_on,
  Boolean $dhcp_managed = $::foreman_proxy::params::dhcp_managed,
  String $dhcp_provider = $::foreman_proxy::params::dhcp_provider,
  Array[String] $dhcp_subnets = $::foreman_proxy::params::dhcp_subnets,
  Array[String] $dhcp_option_domain = $::foreman_proxy::params::dhcp_option_domain,
  Optional[Array[String]] $dhcp_search_domains = $::foreman_proxy::params::dhcp_search_domains,
  String $dhcp_interface = $::foreman_proxy::params::dhcp_interface,
  Optional[String] $dhcp_gateway = $::foreman_proxy::params::dhcp_gateway,
  Variant[Undef, Boolean, String] $dhcp_range = $::foreman_proxy::params::dhcp_range,
  Optional[String] $dhcp_pxeserver = $::foreman_proxy::params::dhcp_pxeserver,
  String $dhcp_nameservers = $::foreman_proxy::params::dhcp_nameservers,
  String $dhcp_server = $::foreman_proxy::params::dhcp_server,
  Stdlib::Absolutepath $dhcp_config = $::foreman_proxy::params::dhcp_config,
  Stdlib::Absolutepath $dhcp_leases = $::foreman_proxy::params::dhcp_leases,
  Optional[String] $dhcp_key_name = $::foreman_proxy::params::dhcp_key_name,
  Optional[String] $dhcp_key_secret = $::foreman_proxy::params::dhcp_key_secret,
  Integer[0, 65535] $dhcp_omapi_port = $::foreman_proxy::params::dhcp_omapi_port,
  Optional[String] $dhcp_peer_address = $::foreman_proxy::params::dhcp_peer_address,
  Enum['standalone', 'primary', 'secondary'] $dhcp_node_type = $::foreman_proxy::params::dhcp_node_type,
  Optional[String] $dhcp_failover_address = $::foreman_proxy::params::dhcp_failover_address,
  Optional[Integer[0, 65535]] $dhcp_failover_port = $::foreman_proxy::params::dhcp_failover_port,
  Optional[Integer[0]] $dhcp_max_response_delay = $::foreman_proxy::params::dhcp_max_response_delay,
  Optional[Integer[0]] $dhcp_max_unacked_updates = $::foreman_proxy::params::dhcp_max_unacked_updates,
  Optional[Integer[0]] $dhcp_mclt = $::foreman_proxy::params::dhcp_mclt,
  Optional[Integer[0, 255]] $dhcp_load_split = $::foreman_proxy::params::dhcp_load_split,
  Optional[Integer[0]] $dhcp_load_balance = $::foreman_proxy::params::dhcp_load_balance,
  Boolean $dns = $::foreman_proxy::params::dns,
  Foreman_proxy::ListenOn $dns_listen_on = $::foreman_proxy::params::dns_listen_on,
  Boolean $dns_managed = $::foreman_proxy::params::dns_managed,
  String $dns_provider = $::foreman_proxy::params::dns_provider,
  String $dns_interface = $::foreman_proxy::params::dns_interface,
  String $dns_zone = $::foreman_proxy::params::dns_zone,
  Optional[Variant[String, Array[String]]] $dns_reverse = $::foreman_proxy::params::dns_reverse,
  String $dns_server = $::foreman_proxy::params::dns_server,
  Integer[0] $dns_ttl = $::foreman_proxy::params::dns_ttl,
  String $dns_tsig_keytab = $::foreman_proxy::params::dns_tsig_keytab,
  String $dns_tsig_principal = $::foreman_proxy::params::dns_tsig_principal,
  Array[String] $dns_forwarders = $::foreman_proxy::params::dns_forwarders,
  String $libvirt_network = $::foreman_proxy::params::libvirt_network,
  String $libvirt_connection = $::foreman_proxy::params::libvirt_connection,
  Boolean $bmc = $::foreman_proxy::params::bmc,
  Foreman_proxy::ListenOn $bmc_listen_on = $::foreman_proxy::params::bmc_listen_on,
  Enum['ipmitool', 'freeipmi', 'shell'] $bmc_default_provider = $::foreman_proxy::params::bmc_default_provider,
  Boolean $realm = $::foreman_proxy::params::realm,
  Boolean $realm_split_config_files = $::foreman_proxy::params::realm_split_config_files,
  Foreman_proxy::ListenOn $realm_listen_on = $::foreman_proxy::params::realm_listen_on,
  String $realm_provider = $::foreman_proxy::params::realm_provider,
  Stdlib::Absolutepath $realm_keytab = $::foreman_proxy::params::realm_keytab,
  String $realm_principal = $::foreman_proxy::params::realm_principal,
  Stdlib::Absolutepath $freeipa_config = $::foreman_proxy::params::freeipa_config,
  Boolean $freeipa_remove_dns = $::foreman_proxy::params::freeipa_remove_dns,
  Variant[Undef, String[0], Stdlib::Absolutepath] $keyfile = $::foreman_proxy::params::keyfile,
  Boolean $register_in_foreman = $::foreman_proxy::params::register_in_foreman,
  Stdlib::HTTPUrl $foreman_base_url = $::foreman_proxy::params::foreman_base_url,
  String $registered_name = $::foreman_proxy::params::registered_name,
  Optional[Stdlib::HTTPUrl] $registered_proxy_url = $::foreman_proxy::params::registered_proxy_url,
  String $oauth_effective_user = $::foreman_proxy::params::oauth_effective_user,
  String $oauth_consumer_key = $::foreman_proxy::params::oauth_consumer_key,
  String $oauth_consumer_secret = $::foreman_proxy::params::oauth_consumer_secret,
  Optional[Boolean] $puppet_use_cache = $::foreman_proxy::params::puppet_use_cache,
) inherits foreman_proxy::params {
  if $bind_host =~ String {
    warning('foreman_proxy::bind_host should be changed to an array, support for string only is deprecated')
  }

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
