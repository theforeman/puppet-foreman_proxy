# Default parameters for the Realm AD smart proxy plugin
class foreman_proxy::plugin::realm::ad::params {
  $realm                 = undef
  $domain_controller     = undef
  $ou                    = undef
  $computername_prefix   = undef
  $computername_hash     = undef
  $computername_use_fqdn = undef
  $group                 = undef
  $version               = undef
}
