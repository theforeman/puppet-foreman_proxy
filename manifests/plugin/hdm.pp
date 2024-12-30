# = Foreman Proxy HDM plugin
#
# This class installs the HDM plugin
#
# === Parameters:
#
# $hdm_url::                  the API endpoint of your HDM installation
#
# $hdm_user::                 email address of the API-role user inside of HDM - can be ommited if HDM runs unauthenticated
#
# $hdm_password::             password of the HDM API user - can be ommited if HDM runs unauthenticated
#
# === Advanced parameters:
#
# $enabled::                  enables/disables the HDM plugin
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
    feature       => 'Hdm',
    listen_on     => $listen_on,
    version       => $version,
  }
}
