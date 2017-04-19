#
# == Define: foreman_proxy::settings_file
#
# Generates a settings file for a module
#
# == Parameters
#
# $module::        Whether the config file is a proxy module or not
#
# $enabled::       If module is enabled or not
#
# $listen_on::     Whether the module listens on https, http, or both
#
# $path::          Path to module's settings file, by default
#                  '/etc/foreman-proxy/settings.d/<module name>.yml
#
# $template_path:: Location of the template used to generate module's settings
#
# $owner::         Settings file's owner
#
# $group:          Settings file's group
#
# $mode:           Settings file's mode
#
define foreman_proxy::settings_file (
  Boolean $module = true,
  Boolean $enabled = true,
  Foreman_proxy::ListenOn $listen_on = 'https',
  Stdlib::Absolutepath $path = "${::foreman_proxy::etc}/foreman-proxy/settings.d/${title}.yml",
  String $owner = 'root',
  String $group = $::foreman_proxy::user,
  String $mode = '0640',
  String $template_path = "foreman_proxy/${title}.yml.erb",
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
    } else {
      $module_enabled = false
    }
  }

  file {$path:
    ensure  => file,
    content => template($template_path),
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    require => Class['::foreman_proxy::install'],
    notify  => Class['foreman_proxy::service'],
  }
}
