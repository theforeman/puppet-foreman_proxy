# == Class: foreman_proxy
#
# Installs and configures the foreman-proxy
#
# === Parameters:
#
# $ssl::          Should we enable ssl within foreman-proxy.
#                 Defaults to 'true'.
#
# $ssl_ca::       Override the ca certificate to use.
#                 Defaults to either what is configured in puppet::server
#                 or uses a sane default (see foreman_proxy::params).
#
# $ssl_cert::     Override the (signed) ssl certificate to use.
#                 Defaults to either what is configured in puppet::server
#                 or uses a sane default (see foreman_proxy::params).
#
# $ssl_key::      Override the (private) ssl key to use.
#                 Defaults to either what is configured in puppet::server
#                 or uses a sane default (see foreman_proxy::params).
#
# === Todo:
#
# TODO: Document more parameters.
#
class foreman_proxy (
  $repo                = $foreman_proxy::params::repo,
  $custom_repo         = $foreman_proxy::params::custom_repo,
  $port                = $foreman_proxy::params::port,
  $dir                 = $foreman_proxy::params::dir,
  $user                = $foreman_proxy::params::user,
  $log                 = $foreman_proxy::params::log,
  $ssl                 = $foreman_proxy::params::ssl,
  # ssl defaults require a little bit more logic.
  $ssl_ca              = undef,
  $ssl_cert            = undef,
  $ssl_key             = undef,
  $trusted_hosts       = $foreman_proxy::params::trusted_hosts,
  $manage_sudoersd     = $foreman_proxy::params::manage_sudoersd,
  $use_sudoersd        = $foreman_proxy::params::use_sudoersd,
  $puppetca            = $foreman_proxy::params::puppetca,
  $autosign_location   = $foreman_proxy::params::autosign_location,
  $puppetca_cmd        = $foreman_proxy::params::puppetca_cmd,
  $puppet_group        = $foreman_proxy::params::puppet_group,
  $puppetrun           = $foreman_proxy::params::puppetrun,
  $puppetrun_cmd       = $foreman_proxy::params::puppetrun_cmd,
  $tftp                = $foreman_proxy::params::tftp,
  $tftp_syslinux_root  = $foreman_proxy::params::tftp_syslinux_root,
  $tftp_syslinux_files = $foreman_proxy::params::tftp_syslinux_files,
  $tftp_root           = $foreman_proxy::params::tftp_root,
  $tftp_dirs           = $foreman_proxy::params::tftp_dirs,
  $tftp_servername     = $foreman_proxy::params::tftp_servername,
  $dhcp                = $foreman_proxy::params::dhcp,
  $dhcp_managed        = $foreman_proxy::params::dhcp_managed,
  $dhcp_interface      = $foreman_proxy::params::dhcp_interface,
  $dhcp_gateway        = $foreman_proxy::params::dhcp_gateway,
  $dhcp_range          = $foreman_proxy::params::dhcp_range,
  $dhcp_nameservers    = $foreman_proxy::params::dhcp_nameservers,
  $dhcp_vendor         = $foreman_proxy::params::dhcp_vendor,
  $dhcp_config         = $foreman_proxy::params::dhcp_config,
  $dhcp_leases         = $foreman_proxy::params::dhcp_leases,
  $dhcp_key_name       = $foreman_proxy::params::dhcp_key_name,
  $dhcp_key_secret     = $foreman_proxy::params::dhcp_key_secret,
  $dns                 = $foreman_proxy::params::dns,
  $dns_interface       = $foreman_proxy::params::dns_interface,
  $dns_reverse         = $foreman_proxy::params::dns_reverse,
  $dns_server          = $foreman_proxy::params::dns_server,
  $dns_forwarders      = $foreman_proxy::params::dns_forwarders,
  $keyfile             = $foreman_proxy::params::keyfile
) inherits foreman_proxy::params {
  class { 'foreman_proxy::install': } ~>
  class { 'foreman_proxy::config': } ~>
  class { 'foreman_proxy::service': }
}
