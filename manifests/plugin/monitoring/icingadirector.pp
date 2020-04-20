# = Foreman Proxy Icinga 2 Director Monitoring plugin
#
# This class installs the Icinga 2 Director Monitoring plugin for Foreman proxy
#
# === Parameters:
#
# $director_url::          URL for icingaweb2-module-director.
#
# $director_cacert::       Path to icingaweb2-module-director server CA certificate file.
#
# $director_user::         Director api user.
#
# $director_password::     Director api password.
#
# $verify_ssl::            Whether smart-proxy should verify the ssl connection
#                          to icingaweb2-module-director.
#
# === Advanced parameters:
#
# $enabled::               Enable this plugin.
#
class foreman_proxy::plugin::monitoring::icingadirector (
  Boolean $enabled = $foreman_proxy::plugin::monitoring::icingadirector::params::enabled,
  Stdlib::HTTPUrl $director_url = $foreman_proxy::plugin::monitoring::icingadirector::params::director_url,
  Stdlib::Absolutepath $director_cacert = $foreman_proxy::plugin::monitoring::icingadirector::params::director_cacert,
  Optional[String] $director_user = $foreman_proxy::plugin::monitoring::icingadirector::params::director_user,
  Optional[String] $director_password = $foreman_proxy::plugin::monitoring::icingadirector::params::director_password,
  Boolean $verify_ssl = $foreman_proxy::plugin::monitoring::icingadirector::params::verify_ssl,
) inherits foreman_proxy::plugin::monitoring::icingadirector::params {
  include foreman_proxy::plugin::monitoring

  foreman_proxy::settings_file { 'monitoring_icingadirector':
    template_path => 'foreman_proxy/plugin/monitoring_icingadirector.yml.erb',
  }
}
