# = Foreman Proxy Pulp plugin
#
# This class installs pulp plugin
#
# === Parameters:
#
# $group::        group owner of the configuration file
#
# $enabled::      enables/disables the plugin
#
# $pulp_url::     pulp url to use
#
class foreman_proxy::plugin::pulp (
  $enabled  = $foreman_proxy::plugin::pulp::params::enabled,
  $group = $foreman_proxy::plugin::pulp::params::group,
  $pulp_url = $foreman_proxy::plugin::pulp::params::pulp_url,
) inherits foreman_proxy::plugin::pulp::params {

  foreman_proxy::plugin {'pulp':
  } ->
  file {'/etc/foreman-proxy/settings.d/pulp.yml':
    ensure  => file,
    content => template('foreman_proxy/plugin/pulp.yml.erb'),
    owner   => 'root',
    group   => $group,
    mode    => '0640',
  }
}
