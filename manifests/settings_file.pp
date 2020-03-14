# @summary Generate a settings file for a module
#
# @param ensure
#   Whether the config file should be a file or absent
#
# @param module
#   Whether the config file is a proxy module or not
#
# @param enabled
#   If module is enabled or not
#
# @param listen_on
#   Whether the module listens on https, http, or both
#
# @param path
#   Path to module's settings file
#
# @param template_path
#   Location of the template used to generate module's settings
#
# @param owner
#   Settings file's owner
#
# @param group
#   Settings file's group
#
# @param mode
#   Settings file's mode
#
# @param feature
#   Feature name advertised by proxy module. If set, foreman_proxy::register
#   will validate the feature name is loaded and advertised.
#
define foreman_proxy::settings_file (
  Enum['file', 'absent'] $ensure = 'file',
  Boolean $module = true,
  Boolean $enabled = true,
  Foreman_proxy::ListenOn $listen_on = 'https',
  Stdlib::Absolutepath $path = "${foreman_proxy::params::config_dir}/settings.d/${title}.yml",
  String $owner = 'root',
  String $group = $foreman_proxy::params::user,
  Stdlib::Filemode $mode = '0640',
  String $template_path = "foreman_proxy/${title}.yml.erb",
  Optional[String] $feature = undef,
) {
  # If the config file is for a proxy module, then we need to know
  # whether it's enabled, and if so, where to listen (https, http, or both).
  # If undefined here, look up the values from the foreman_proxy class.

  if $module {
    if $enabled {
      $module_enabled = $listen_on ? {
        'both'  => true,
        'https' => 'https',
        'http'  => 'http',
        default => false,
      }

      if $feature and $ensure != 'absent' {
        foreman_proxy::feature { $feature: }
      }
    } else {
      $module_enabled = false
    }
  }

  if $ensure == 'absent' {
    $content = undef
  } else {
    $content = template($template_path)
  }

  file {$path:
    ensure  => $ensure,
    content => $content,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
  }
}
