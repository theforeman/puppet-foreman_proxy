# @summary Install a Foreman Proxy plugin that's a module
#
# @param version
#   The version to ensure
#
# @param package
#   The package to install
#
# @param enabled
#  Whether the module is enabled or disabled.
#
# @param feature
#   Each module is exposed as a feature to Foreman on registration. When using
#   `foreman_proxy::register`, these features are checked to verify it works
#   end to end.
#
# @param listen_on
#   When enabled, it's configured to listen on HTTPS (default), HTTP or both.
#   Unless the module explicitly needs HTTP (usually because clients needs it),
#   HTTPS should be chosen.
#
# @param template_path
#   An optional template path
#
define foreman_proxy::plugin::module (
  Optional[String] $version = undef,
  Optional[String] $package = undef,
  Boolean $enabled = false,
  Optional[Foreman_proxy::ListenOn] $listen_on = undef,
  String $template_path = "foreman_proxy/plugin/${title}.yml.erb",
  String $feature = $title.capitalize(),
) {
  foreman_proxy::plugin { $title:
    version => $version,
    package => $package,
  }
  -> foreman_proxy::module { $name:
    enabled       => $enabled,
    feature       => $feature,
    listen_on     => $listen_on,
    template_path => $template_path,
  }
}
