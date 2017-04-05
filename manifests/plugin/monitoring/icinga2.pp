# = Foreman Proxy Icinga 2 Monitoring plugin
#
# This class installs the Icinga 2 Monitoring plugin for Foreman proxy
#
# === Parameters:
#
# $server::                Icinga2 server hostname.
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
  Boolean $enabled = $::foreman_proxy::plugin::monitoring::icinga2::params::enabled,
  String $server = $::foreman_proxy::plugin::monitoring::icinga2::params::server,
  Stdlib::Absolutepath $api_cacert = $::foreman_proxy::plugin::monitoring::icinga2::params::api_cacert,
  String $api_user = $::foreman_proxy::plugin::monitoring::icinga2::params::api_user,
  Stdlib::Absolutepath $api_usercert = $::foreman_proxy::plugin::monitoring::icinga2::params::api_usercert,
  Stdlib::Absolutepath $api_userkey = $::foreman_proxy::plugin::monitoring::icinga2::params::api_userkey,
  Optional[String] $api_password = $::foreman_proxy::plugin::monitoring::icinga2::params::api_password,
  Boolean $verify_ssl = $::foreman_proxy::plugin::monitoring::icinga2::params::verify_ssl,
) inherits foreman_proxy::plugin::monitoring::icinga2::params {
  include ::foreman_proxy::plugin::monitoring

  foreman_proxy::settings_file { 'monitoring_icinga2':
    module        => false,
    template_path => 'foreman_proxy/plugin/monitoring_icinga2.yml.erb',
  }
}
