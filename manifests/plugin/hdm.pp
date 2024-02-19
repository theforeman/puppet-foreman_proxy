# = Foreman Proxy HDM plugin
#
# This class installs the HDM plugin
#
# === Parameters:
#
# === Advanced parameters:
#
# $enabled::                  enables/disables the acd plugin
#
# $listen_on::                proxy feature listens on http, https, or both
#
# $version::                  plugin package version, it's passed to ensure parameter of package resource
#                             can be set to specific version number, 'latest', 'present' etc.
#
class foreman_proxy::plugin::hdm (
  String[1]               $hdm_url,
  Optional[String]        $version      = undef,
  Boolean                 $enabled      = true,
  Foreman_proxy::ListenOn $listen_on    = 'https',
  Optional[String[1]]     $hdm_user     = undef,
  Optional[String[1]]     $hdm_password = undef,
) {
  foreman_proxy::plugin::module { 'hdm':
    template_path => 'foreman_proxy/plugin/hdm.yml.erb',
    enabled       => $enabled,
    feature       => 'HDM',
    listen_on     => $listen_on,
    version       => $version,
  }
}
