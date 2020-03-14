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
define foreman_proxy::module (
  Boolean $enabled = false,
  Foreman_proxy::ListenOn $listen_on = 'https',
  String $feature = upcase($title),
) {
  foreman_proxy::settings_file { $name:
    module    => true,
    enabled   => $enabled,
    feature   => $feature,
    listen_on => $listen_on,
  }
}
