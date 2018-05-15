type Foreman_proxy::AdConfig = Struct[{
  Optional[computername_hash]     => Boolean,
  Optional[computername_prefix]   => String[1],
  Optional[computername_use_fqdn] => Boolean,
  domain_controller               => String[1],
  Optional[ou]                    => String[1],
  realm                           => String[1],
  Optional[version]               => String[1]
}]
