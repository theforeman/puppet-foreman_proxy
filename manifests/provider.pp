# @summary Configure a provider
#
# @param ensure
#   Whether the config file should be a file or absent
#
define foreman_proxy::provider (
  Enum['file', 'absent'] $ensure = 'file',
) {
  foreman_proxy::settings_file { $title:
    ensure        => $ensure,
  }
}
