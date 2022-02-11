# @summary Low level abstraction of Foreman Proxy modules
#
# Foreman Proxy internally has the concept of modules. Some modules have
# providers or even multiple ones. That's not part of this definition.
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
# @param config_context
#   Context to pass to the template
#
define foreman_proxy::module (
  Boolean $enabled = false,
  Foreman_proxy::ListenOn $listen_on = 'https',
  Optional[String] $template_path = undef,
  Hash[String, Any] $config_context = {},
  String $feature = upcase($title),
) {
  if $enabled {
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
    template_path  => $template_path,
    config_context => $config_context + {'module_enabled' => $module_enabled},
  }
}
