# = Foreman Proxy Icinga 2 Monitoring plugin
#
# This class installs the Icinga 2 Monitoring plugin for Foreman proxy
#
# === Parameters:
#
# $server::                Icinga2 server hostname.
#
# $api_port::              Icinga 2 API port.
#
# $api_cacert::            Path to Icinga2 server CA certificate file.
#
# $api_user::              Icinga2 API username.
#
# $api_usercert::          Path to Icinga2 user certificate file.
#
# $api_userkey::           Path to Icinga2 user key file.
#
# $api_password::          Icinga2 API password. If set to undef (default) API
#                          connection is made via certificate and key.
#
# $verify_ssl::            Whether smart-proxy should verify the ssl connection
#                          to Icinga2.
#
# === Advanced parameters:
#
# $enabled::               Enable this plugin.
#
class foreman_proxy::plugin::monitoring::icinga2 (
  Boolean $enabled = true,
  Stdlib::Host $server = $facts['networking']['fqdn'],
  Stdlib::Port $api_port = 5665,
  Stdlib::Absolutepath $api_cacert = '/etc/foreman-proxy/monitoring/ca.crt',
  String $api_user = 'foreman',
  Stdlib::Absolutepath $api_usercert = '/etc/foreman-proxy/monitoring/foreman.crt',
  Stdlib::Absolutepath $api_userkey = '/etc/foreman-proxy/monitoring/foreman.key',
  Optional[String] $api_password = undef,
  Boolean $verify_ssl = true,
) {
  include foreman_proxy::plugin::monitoring

  foreman_proxy::settings_file { 'monitoring_icinga2':
    template_path => 'foreman_proxy/plugin/monitoring_icinga2.yml.erb',
  }
}
