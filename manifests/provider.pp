# @summary Configure a provider
#
# @param ensure
#   Whether the config file should be a file or absent
#
# @param template_path
#   An optional template path
#
define foreman_proxy::provider (
  Enum['file', 'absent'] $ensure = 'file',
  Optional[String] $template_path = undef,
) {
  foreman_proxy::settings_file { $title:
    ensure        => $ensure,
    template_path => $template_path,
  }
}
