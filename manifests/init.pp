# Install, configure and run a foreman proxy
#
# === Parameters:
#
# $version::                    foreman package version, it's passed to ensure parameter of package resource
#                               can be set to specific version number, 'latest', 'present' etc.
#
# $ensure_packages_version::    control extra packages version, it's passed to ensure parameter of package resource
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
# $groups::                     Array of additional groups for the foreman proxy user
#
# $log::                        Foreman proxy log file, 'STDOUT', 'SYSLOG' or 'JOURNAL'
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
# $tls_disabled_versions::      List of TLS versions that will be disabled from the default
#
# $trusted_hosts::              Only hosts listed will be permitted, empty array to disable authorization
#
# $puppetca::                   Enable Puppet CA feature
#
# $puppetca_listen_on::         Protocols for the Puppet CA feature to listen on
#
# $ssldir::                     Puppet CA SSL directory
#
# $httpboot::                   Enable HTTPBoot feature. In most deployments this requires HTTP to be enabled as well.
#
# $puppetdir::                  Puppet var directory
#
# $puppet_group::               Groups of Foreman proxy user
#
# $autosignfile::               Hostname-Whitelisting only: Location of puppets autosign.conf
#
# $puppetca_tokens_file::       Token-Whitelisting only: Location of the tokens.yaml
#
# $manage_puppet_group::        Whether to ensure the $puppet_group exists.  Also ensures group owner of ssl keys and certs is $puppet_group
#                               Not applicable when ssl is false.
#
# $puppet::                     Enable Puppet module for environment imports and Puppet runs
#
# $puppet_listen_on::           Protocols for the Puppet feature to listen on
#
# $puppet_url::                 URL of the Puppet master itself for API requests
#
# $puppet_ssl_ca::              SSL CA used to verify connections when accessing the Puppet master API
#
# $puppet_ssl_cert::            SSL certificate used when accessing the Puppet master API
#
# $puppet_ssl_key::             SSL private key used when accessing the Puppet master API
#
# $puppet_api_timeout::         Timeout in seconds when accessing Puppet environment classes API
#
# $templates::                  Enable templates feature
#
# $templates_listen_on::        Templates proxy to listen on https, http, or both
#
# $template_url::               URL a client should use for provisioning templates
#
# $registration::               Enable Registration feature
#
# $registration_listen_on::     Registration proxy to listen on https, http, or both
#
# $logs::                       Enable Logs (log buffer) feature
#
# $logs_listen_on::             Logs proxy to listen on https, http, or both
#
# $tftp::                       Enable TFTP feature
#
# $tftp_listen_on::             TFTP proxy to listen on https, http, or both
#
# $tftp_managed::               The TFTP daemon is managed by this module.
#
# $tftp_manage_wget::           If enabled will install the wget package
#
# $tftp_root::                  TFTP root directory
#
# $tftp_dirs::                  Directories to be create in $tftp_root
#
# $tftp_servername::            Defines the TFTP Servername to use, overrides the name in the subnet declaration
#
# $tftp_replace_grub2_cfg::     Determines if grub2.cfg will be replaced
#
# $dhcp::                       Enable DHCP feature
#
# $dhcp_listen_on::             DHCP proxy to listen on https, http, or both
#
# $dhcp_managed::               The DHCP daemon is managed by this module
#
# $dhcp_provider::              DHCP provider for the DHCP module
#
# $dhcp_subnets::               Subnets list to restrict DHCP management to
#
# $dhcp_ping_free_ip::          Perform ICMP and TCP ping when searching free IPs from the pool. This makes
#                               sure that active IP address is not suggested as free, however in locked down
#                               network environments this can cause no free IPs.
#
# $dhcp_option_domain::         DHCP use the dhcpd config option domain-name
#
# $dhcp_search_domains::        DHCP search domains option
#
# $dhcp_interface::             DHCP listen interface
#
# $dhcp_additional_interfaces:: Additional DHCP listen interfaces (in addition to dhcp_interface). Note: as opposed to dhcp_interface
#                               *no* subnet will be provisioned for any of the additional DHCP listen interfaces. Please configure any
#                               additional subnets using `dhcp::pool` and related resource types (provided by the theforeman/puppet-dhcp
#                               module).
#
# $dhcp_gateway::               DHCP pool gateway
#
# $dhcp_range::                 Space-separated DHCP pool range
#
# $dhcp_nameservers::           DHCP nameservers, comma-separated
#
# $dhcp_pxeserver::             DHCP "next-server" value, defaults otherwise to IP of dhcp_interface
#
# $dhcp_pxefilename::           DHCP "filename" value, defaults otherwise to pxelinux.0
#
# $dhcp_ipxefilename::          iPXE DHCP "filename" value, If not specified, it's determined dynamically.
#                               When the templates feature is enabled, the template_url is used.
#
# $dhcp_ipxe_bootstrap::        Enable or disable iPXE bootstrap(discovery) feature
#
# $dhcp_network::               DHCP server network value, defaults otherwise to value based on IP of dhcp_interface
#
# $dhcp_netmask::               DHCP server netmask value, defaults otherwise to value based on IP of dhcp_interface
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
# $dns_managed::                The DNS daemon is managed by this module. Only supported for the nsupdate and nsupdate_gss DNS providers.
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
# $bmc_redfish_verify_ssl::     BMC Redfish verify ssl.
#
# $bmc_ssh_user::               BMC SSH user.
#
# $bmc_ssh_key::                BMC SSH key location.
#
# $bmc_ssh_powerstatus::        BMC SSH powerstatus command.
#
# $bmc_ssh_powercycle::         BMC SSH powercycle command.
#
# $bmc_ssh_poweroff::           BMC SSH poweroff command.
#
# $bmc_ssh_poweron::            BMC SSH poweron command.
#
# $keyfile::                    DNS server keyfile path
#
# $realm::                      Enable realm management feature
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
# $dhcp_manage_acls::           Whether to manage DHCP directory ACLs. This allows the Foreman Proxy user to access even if the directory mode is 0750.
#
# $httpboot_listen_on::         HTTPBoot proxy to listen on https, http, or both
#
# $puppetca_provider::          Whether to use puppetca_hostname_whitelisting or puppetca_token_whitelisting
#
# $puppetca_sign_all::          Token-whitelisting only: Whether to sign all CSRs without checking their token
#
# $puppetca_token_ttl::         Token-whitelisting only: Fallback time (in minutes) after which tokens will expire
#
# $puppetca_certificate::       Token-whitelisting only: Certificate to use when encrypting tokens (undef to use SSL certificate)
#
# $registration_url::           URL that hosts will connect to when registering
#
class foreman_proxy (
  String $version = 'present',
  Enum['latest', 'present', 'installed', 'absent'] $ensure_packages_version = 'installed',
  Variant[Array[String], String] $bind_host = ['*'],
  Stdlib::Port $http_port = 8000,
  Stdlib::Port $ssl_port = 8443,
  Array[String] $groups = [],
  Variant[Enum['STDOUT', 'SYSLOG', 'JOURNAL'], Stdlib::Absolutepath] $log = '/var/log/foreman-proxy/proxy.log',
  Enum['WARN', 'DEBUG', 'ERROR', 'FATAL', 'INFO', 'UNKNOWN'] $log_level = 'INFO',
  Integer[0] $log_buffer = 2000,
  Integer[0] $log_buffer_errors = 1000,
  Boolean $http = false,
  Boolean $ssl = true,
  Stdlib::Absolutepath $ssl_ca = $foreman_proxy::params::ssl_ca,
  Stdlib::Absolutepath $ssl_cert = $foreman_proxy::params::ssl_cert,
  Stdlib::Absolutepath $ssl_key = $foreman_proxy::params::ssl_key,
  Optional[Stdlib::Absolutepath] $foreman_ssl_ca = undef,
  Optional[Stdlib::Absolutepath] $foreman_ssl_cert = undef,
  Optional[Stdlib::Absolutepath] $foreman_ssl_key = undef,
  Array[String] $trusted_hosts = $foreman_proxy::params::trusted_hosts,
  Array[String] $ssl_disabled_ciphers = [],
  Array[String] $tls_disabled_versions = [],
  Boolean $puppetca = true,
  Foreman_proxy::ListenOn $puppetca_listen_on = 'https',
  Stdlib::Absolutepath $ssldir = $foreman_proxy::params::ssldir,
  Stdlib::Absolutepath $puppetdir = $foreman_proxy::params::puppetdir,
  String $puppet_group = 'puppet',
  String $puppetca_provider = 'puppetca_hostname_whitelisting',
  Stdlib::Absolutepath $autosignfile = $foreman_proxy::params::autosignfile,
  Boolean $puppetca_sign_all = false,
  Stdlib::Absolutepath $puppetca_tokens_file = '/var/lib/foreman-proxy/tokens.yml',
  Integer[0] $puppetca_token_ttl = 360,
  Optional[Stdlib::Absolutepath] $puppetca_certificate = undef,
  Boolean $manage_puppet_group = true,
  Boolean $puppet = true,
  Foreman_proxy::ListenOn $puppet_listen_on = 'https',
  Stdlib::HTTPUrl $puppet_url = $foreman_proxy::params::puppet_url,
  Stdlib::Absolutepath $puppet_ssl_ca = $foreman_proxy::params::ssl_ca,
  Stdlib::Absolutepath $puppet_ssl_cert = $foreman_proxy::params::ssl_cert,
  Stdlib::Absolutepath $puppet_ssl_key = $foreman_proxy::params::ssl_key,
  Integer[0] $puppet_api_timeout = 30,
  Boolean $templates = false,
  Foreman_proxy::ListenOn $templates_listen_on = 'both',
  Stdlib::HTTPUrl $template_url = $foreman_proxy::params::template_url,
  Boolean $registration = false,
  Foreman_proxy::ListenOn $registration_listen_on = 'https',
  Boolean $logs = true,
  Foreman_proxy::ListenOn $logs_listen_on = 'https',
  Boolean $httpboot = false,
  Foreman_proxy::ListenOn $httpboot_listen_on = 'both',
  Boolean $tftp = false,
  Foreman_proxy::ListenOn $tftp_listen_on = 'https',
  Boolean $tftp_managed = true,
  Boolean $tftp_manage_wget = true,
  Optional[Stdlib::Absolutepath] $tftp_root = $foreman_proxy::params::tftp_root,
  Optional[Array[Stdlib::Absolutepath]] $tftp_dirs = undef,
  Optional[String] $tftp_servername = undef,
  Boolean $tftp_replace_grub2_cfg = false,
  Boolean $dhcp = false,
  Foreman_proxy::ListenOn $dhcp_listen_on = 'https',
  Boolean $dhcp_managed = true,
  String $dhcp_provider = 'isc',
  Array[String] $dhcp_subnets = [],
  Boolean $dhcp_ping_free_ip = true,
  Array[String] $dhcp_option_domain = $foreman_proxy::params::dhcp_option_domain,
  Optional[Array[String]] $dhcp_search_domains = undef,
  String $dhcp_interface = $foreman_proxy::params::dhcp_interface,
  Array[String] $dhcp_additional_interfaces = [],
  Optional[String] $dhcp_gateway = undef,
  Variant[Undef, Boolean, String] $dhcp_range = undef,
  Optional[Stdlib::IP::Address::V4::Nosubnet] $dhcp_pxeserver = undef,
  String $dhcp_pxefilename = 'pxelinux.0',
  Optional[String[1]] $dhcp_ipxefilename = undef,
  Boolean $dhcp_ipxe_bootstrap = false,
  Optional[Stdlib::IP::Address::V4::Nosubnet] $dhcp_network = undef,
  Optional[Stdlib::IP::Address::V4::Nosubnet] $dhcp_netmask = undef,
  String $dhcp_nameservers = 'default',
  String $dhcp_server = '127.0.0.1',
  Stdlib::Absolutepath $dhcp_config = $foreman_proxy::params::dhcp_config,
  Stdlib::Absolutepath $dhcp_leases = $foreman_proxy::params::dhcp_leases,
  Optional[String] $dhcp_key_name = undef,
  Optional[String] $dhcp_key_secret = undef,
  Stdlib::Port $dhcp_omapi_port = 7911,
  Optional[String] $dhcp_peer_address = undef,
  Enum['standalone', 'primary', 'secondary'] $dhcp_node_type = 'standalone',
  Optional[String] $dhcp_failover_address = $foreman_proxy::params::dhcp_failover_address,
  Stdlib::Port $dhcp_failover_port = 519,
  Integer[0] $dhcp_max_response_delay = 30,
  Integer[0] $dhcp_max_unacked_updates = 10,
  Integer[0] $dhcp_mclt = 300,
  Integer[0, 255] $dhcp_load_split = 255,
  Integer[0] $dhcp_load_balance = 3,
  Boolean $dhcp_manage_acls = $foreman_proxy::params::dhcp_manage_acls,
  Boolean $dns = false,
  Foreman_proxy::ListenOn $dns_listen_on = 'https',
  Boolean $dns_managed = true,
  String $dns_provider = 'nsupdate',
  String $dns_interface = $foreman_proxy::params::dns_interface,
  Optional[Stdlib::Fqdn] $dns_zone = $foreman_proxy::params::dns_zone,
  Optional[Variant[String, Array[String]]] $dns_reverse = undef,
  String $dns_server = '127.0.0.1',
  Integer[0] $dns_ttl = 86400,
  String $dns_tsig_keytab = $foreman_proxy::params::dns_tsig_keytab,
  String $dns_tsig_principal = $foreman_proxy::params::dns_tsig_principal,
  Array[String] $dns_forwarders = [],
  String $libvirt_network = 'default',
  String $libvirt_connection = 'qemu:///system',
  Boolean $bmc = false,
  Foreman_proxy::ListenOn $bmc_listen_on = 'https',
  Enum['ipmitool', 'freeipmi', 'redfish', 'shell', 'ssh'] $bmc_default_provider = 'ipmitool',
  Boolean $bmc_redfish_verify_ssl = true,
  String $bmc_ssh_user = 'root',
  Stdlib::Absolutepath $bmc_ssh_key = '/usr/share/foreman/.ssh/id_rsa',
  # lint:ignore:quoted_booleans
  String $bmc_ssh_powerstatus = 'true',
  # lint:endignore
  String $bmc_ssh_powercycle = 'shutdown -r +1',
  String $bmc_ssh_poweroff = 'shutdown +1',
  # lint:ignore:quoted_booleans
  String $bmc_ssh_poweron = 'false',
  # lint:endignore
  Boolean $realm = false,
  Foreman_proxy::ListenOn $realm_listen_on = 'https',
  String $realm_provider = 'freeipa',
  Stdlib::Absolutepath $realm_keytab = $foreman_proxy::params::realm_keytab,
  String $realm_principal = $foreman_proxy::params::realm_principal,
  Stdlib::Absolutepath $freeipa_config = '/etc/ipa/default.conf',
  Boolean $freeipa_remove_dns = true,
  Variant[Undef, String[0], Stdlib::Absolutepath] $keyfile = $foreman_proxy::params::keyfile,
  Boolean $register_in_foreman = true,
  Stdlib::HTTPUrl $foreman_base_url = $foreman_proxy::params::foreman_base_url,
  String $registered_name = $foreman_proxy::params::registered_name,
  Optional[Stdlib::HTTPUrl] $registered_proxy_url = undef,
  String $oauth_effective_user = 'admin',
  String $oauth_consumer_key = $foreman_proxy::params::oauth_consumer_key,
  String $oauth_consumer_secret = $foreman_proxy::params::oauth_consumer_secret,
  Optional[Stdlib::HTTPUrl] $registration_url = undef,
) inherits foreman_proxy::params {
  if $bind_host =~ String {
    warning('foreman_proxy::bind_host should be changed to an array, support for string only is deprecated')
  }

  $real_registered_proxy_url = pick($registered_proxy_url, "https://${facts['networking']['fqdn']}:${ssl_port}")
  contain foreman_proxy::install
  contain foreman_proxy::config
  contain foreman_proxy::service
  contain foreman_proxy::register

  Anchor <| title == 'foreman::repo' |> ~> Class['foreman_proxy::install']

  # lint:ignore:spaceship_operator_without_tag
  Class['foreman_proxy::install']
  ~> Class['foreman_proxy::config']
  ~> Foreman_proxy::Plugin <| |>
  ~> Class['foreman_proxy::service']
  ~> Class['foreman_proxy::register']

  Class['foreman_proxy::install'] -> Foreman_proxy::Settings_file <| |> ~> Class['foreman_proxy::service']
  # lint:endignore
}
