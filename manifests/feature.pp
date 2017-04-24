# Declares that a smart proxy feature should be present and enabled
#
# Used by foreman_proxy::register to specify that all of the expected features
# should be present and enabled. Uses datacat to merge an array of features.
#
define foreman_proxy::feature {
  datacat_fragment { "foreman_proxy::enabled_features::${name}":
    target => 'foreman_proxy::enabled_features',
    data   => { 'features' => [$name] },
  }
}
