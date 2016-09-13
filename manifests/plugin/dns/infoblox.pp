# = Foreman Proxy Infoblox DNS plugin
#
# This class installs the Infoblox DNS plugin for Foreman proxy
#
# === Parameters:
#
# $dns_server:: The address of the Infoblox server
#
# $username::   The username of the Infoblox user
#
# $password::   The password of the Infoblox user
#
class foreman_proxy::plugin::dns::infoblox (
  $dns_server = $::foreman_proxy::plugin::dns::infoblox::params::dns_server,
  $username   = $::foreman_proxy::plugin::dns::infoblox::params::username,
  $password   = $::foreman_proxy::plugin::dns::infoblox::params::password,
) inherits foreman_proxy::plugin::dns::infoblox::params {
  validate_string($dns_server, $username, $password)

  foreman_proxy::plugin { 'dns_infoblox':
  } ->
  foreman_proxy::settings_file { 'dns_infoblox':
    module        => false,
    template_path => 'foreman_proxy/plugin/dns_infoblox.yml.erb',
  }
}
