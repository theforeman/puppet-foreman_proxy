# @summary Global overrides on parameters that hardly ever change
#
# @param user
#   The user under which Foreman Proxy runs
#
# @param dir
#   The directory where Foreman Proxy is deployed
#
# @param plugin_version
#   The default plugin package state to ensure
#
class foreman_proxy::globals (
  Optional[String] $user = undef,
  Optional[Stdlib::Absolutepath] $dir = undef,
  Enum['latest', 'present', 'installed', 'absent'] $plugin_version = 'installed',
) {
}
