# @summary Low level abstraction of Foreman Proxy modules
#
# Foreman Proxy internally has the concept of modules. Some modules have
# providers or even multiple ones. That's not part of this definition.
#
# @param ensure
#  Whether the module is expected to be present or absent
#
# @param enabled
#  Whether the module is enabled or disabled.
#
# @param listen_on
#   When enabled, it's configured to listen on HTTPS (default), HTTP or both.
#   Unless the module explicitly needs HTTP (usually because clients needs it),
#   HTTPS should be chosen.
#
# @param feature
#   Each module is exposed as a feature to Foreman on registration.
#   foreman_proxy::register will validate the feature name is loaded and
#   advertised.
#
# @param template_path
#   An optional template path
#
define foreman_proxy::module (
  Enum['present', 'absent'] $ensure = 'present',
  Boolean $enabled = false,
  Foreman_proxy::ListenOn $listen_on = 'https',
  Optional[String] $template_path = undef,
  String $feature = $title.capitalize(),
) {
  if $ensure != 'absent' and $enabled {
    $module_enabled = $listen_on ? {
      'both'  => 'true',
      'https' => 'https',
      'http'  => 'http',
      default => 'false',
    }

    foreman_proxy::feature { $feature: }
  } else {
    $module_enabled = 'false'
  }

  foreman_proxy::settings_file { $name:
    ensure         => bool2str($ensure == 'present', 'file', 'absent'),
    module_enabled => $module_enabled,
    template_path  => $template_path,
  }
}
