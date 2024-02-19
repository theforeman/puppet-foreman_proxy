# = Foreman Proxy HDM plugin
#
# This class installs the HDM plugin
#
# === Parameters:
#
# === Advanced parameters:
#
# $hdm_url::                  the API endpoint of your HDM installation
#
# $enabled::                  enables/disables the HDM plugin
#
# $listen_on::                proxy feature listens on http, https, or both
#
# $version::                  plugin package version, it's passed to ensure parameter of package resource
#                             can be set to specific version number, 'latest', 'present' etc.
#
# $hdm_user::                 email address of the API-role user inside of HDM - can be ommited if HDM runs unauthenticated
#
# $hdm_password::             password of the HDM API use - can be ommited if HDM runs unauthenticatedr
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
