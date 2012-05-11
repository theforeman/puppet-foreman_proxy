class foreman_proxy::proxydns {
  include foreman_proxy::params
  include dns

  $ip_temp = "::ipaddress_${foreman_proxy::params::dns_interface}"
  $ip      = inline_template("<%= scope.lookupvar(ip_temp) %>")

  dns::zone { "${::domain}":
    soa     => "${::fqdn}",
    reverse => "false",
    soaip   => "${ip}",
  }

  dns::zone { "${foreman_proxy::params::dns_reverse}":
    soa     => "${::fqdn}",
    reverse => "true",
    soaip   => "${ip}",
  }
}
