# Configure the DNS component
class foreman_proxy::proxydns {
  class { '::dns':
    forwarders => $foreman_proxy::dns_forwarders,
  }

  ensure_packages([$foreman_proxy::params::nsupdate])

  # puppet fact names are converted from ethX.X and ethX:X to ethX_X
  # so for alias and vlan interfaces we have to modify the name accordingly
  $interface_fact_name = regsubst($foreman_proxy::dns_interface, '[.:]', '_')
  $ip = inline_template("<%= scope.lookupvar('::ipaddress_${interface_fact_name}') %>")

  if ! is_ip_address($ip) {
    fail("Could not get the ip address from fact ipaddress_${interface_fact_name}")
  }

  ::dns::zone { $foreman_proxy::dns_zone:
    soa     => $::fqdn,
    reverse => false,
    soaip   => $ip,
  }

  ::dns::zone { $foreman_proxy::dns_reverse:
    soa     => $::fqdn,
    reverse => true,
    soaip   => $ip,
  }
}
