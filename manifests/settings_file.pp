#
# == Define: foreman_proxy::settings_file
#
# Generates a settings file for a module
#
# == Parameters
#
# path: path to module's settings file, by default '/etc/foreman-proxy/settings.d/<module name>.yml
# template_path: location of the template used to generate module's settings
# owner: settings file's owner
# group: settings file's group
# mode: settings file's mode
#
define foreman_proxy::settings_file (
    $path = "/etc/foreman-proxy/settings.d/${title}.yml",
    $template_path = "foreman_proxy/${title}.yml.erb",
    $owner = 'root',
    $group = $::foreman_proxy::user,
    $mode = '0640',
  ) {

  file {$path:
    ensure  => file,
    content => template($template_path),
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    require => Class['foreman_proxy::install'],
    notify  => Class['foreman_proxy::service'],
  }
}
