# = Foreman Proxy Pulp plugin
#
# This class installs pulp plugin
#
# === Parameters:
#
# $group::        group owner of the configuration file
#
# $version::      plugin package version, it's passed to ensure parameter of package resource
#                 can be set to specific version number, 'latest', 'present' etc.
#
# $enabled::      enables/disables the plugin
#
# $pulp_url::     pulp url to use
#
class foreman_proxy::plugin::pulp (
  $enabled  = $::foreman_proxy::plugin::pulp::params::enabled,
  $version  = $::foreman_proxy::plugin::version,
  $group    = $::foreman_proxy::user,
  $pulp_url = $::foreman_proxy::plugin::pulp::params::pulp_url,
) inherits foreman_proxy::plugin::pulp::params {
  $group_real = pick($group, $::foreman_proxy::user)
  validate_string($group_real)

  foreman_proxy::plugin {'pulp':
    version => $version,
  } ->
  file {'/etc/foreman-proxy/settings.d/pulp.yml':
    ensure  => file,
    content => template('foreman_proxy/plugin/pulp.yml.erb'),
    owner   => 'root',
    group   => $group_real,
    mode    => '0640',
  }
}
