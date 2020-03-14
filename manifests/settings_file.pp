# @summary Generate a settings file for a module
#
# @param ensure
#   Whether the config file should be a file or absent
#
# @param module_enabled
#   If module is enabled or not. Only relevant when it's a module.
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
define foreman_proxy::settings_file (
  Enum['file', 'absent'] $ensure = 'file',
  String $module_enabled = 'false',
  Stdlib::Absolutepath $path = "${foreman_proxy::params::config_dir}/settings.d/${title}.yml",
  String $owner = 'root',
  String $group = $foreman_proxy::params::user,
  Stdlib::Filemode $mode = '0640',
  String $template_path = "foreman_proxy/${title}.yml.erb",
) {
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
