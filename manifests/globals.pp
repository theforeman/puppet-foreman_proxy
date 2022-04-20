# @summary Global overrides on parameters that hardly ever change
#
# @param user
#   The user under which Foreman Proxy runs
#
# @param group
#   The group under which Foreman Proxy runs
#
# @param dir
#   The directory where Foreman Proxy is deployed
#
# @param plugin_version
#   The default plugin package state to ensure
#
# @param tftp_syslinux_filenames
#   Syslinux files to install on TFTP (full paths)
#
# @param shell
#   Shell of foreman-proxy user
#
class foreman_proxy::globals (
  Optional[String] $user = undef,
  Optional[String] $group = undef,
  Optional[Stdlib::Absolutepath] $dir = undef,
  Enum['latest', 'present', 'installed', 'absent'] $plugin_version = 'installed',
  Optional[Array[Stdlib::Absolutepath]] $tftp_syslinux_filenames = undef,
  Optional[Stdlib::Absolutepath] $shell = undef,
) {
}
