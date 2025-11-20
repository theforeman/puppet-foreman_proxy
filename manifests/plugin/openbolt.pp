# = Foreman Proxy openbolt plugin
#
# This class installs the OpenBolt plugin
#
# === Parameters:
#
# $environment_path::         Path to the environment with all modules
#
# $workers::                  Define the amount of possible workers
#
# $concurrency::              Define the limit of concurrent connections for executed tasks
#
# $connect_timeout::          Timeout in seconds for connecting to remote systems
#
# === Advanced parameters:
#
# $enabled::                  enables/disables the OpenBolt plugin
#
# $listen_on::                proxy feature listens on http, https, or both
#
# $version::                  plugin package version, it's passed to ensure parameter of package resource
#                             can be set to specific version number, 'latest', 'present' etc.
#
# $log_dir::                  directory where bolt will write logs to
#
class foreman_proxy::plugin::openbolt (
  Optional[String[1]] $version = undef,
  Boolean $enabled = true,
  Foreman_proxy::ListenOn $listen_on = 'https',
  Stdlib::Absolutepath $environment_path = '/etc/puppetlabs/code/environments/production',
  Integer[0] $workers = 20,
  Integer[0] $concurrency = 100,
  Integer[1] $connect_timeout = 30,
  Stdlib::Absolutepath $log_dir = '/var/log/foreman-proxy/openbolt',
) {
  foreman_proxy::plugin::module { 'openbolt':
    template_path => 'foreman_proxy/plugin/openbolt.yml.erb',
    enabled       => $enabled,
    feature       => 'OpenBolt',
    listen_on     => $listen_on,
    version       => $version,
  }
}
