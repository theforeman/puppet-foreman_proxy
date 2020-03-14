# @summary Install a Foreman Proxy plugin that's a provider
#
# @param version
#   The version to ensure. When absent, the config file will be removed as well.
#
# @param package
#   The package to install. Automatically determined by default.
#
# @param template_path
#   An optional template path
#
define foreman_proxy::plugin::provider (
  Optional[String] $version = undef,
  Optional[String] $package = undef,
  String $template_path = "foreman_proxy/plugin/${title}.yml.erb",
) {
  if $version == 'absent' {
    $provider_ensure = 'absent'
  } else {
    $provider_ensure = 'file'
  }

  foreman_proxy::plugin { $title:
    version => $version,
    package => $package,
  }
  -> foreman_proxy::provider { $title:
    ensure        => $provider_ensure,
    template_path => $template_path,
  }
}
