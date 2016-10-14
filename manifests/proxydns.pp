# Configure the DNS component
class foreman_proxy::proxydns {
  class { '::dns':
    forwarders => $foreman_proxy::dns_forwarders,
  }

  ensure_packages([$foreman_proxy::params::nsupdate], { ensure => $foreman_proxy::ensure_packages_version, })

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

  $foreman_proxy::dns_reverse.each |String $reverse| {
    dns::zone { $reverse:
      soa     => $::fqdn,
      reverse => true,
      soaip   => $ip,
    }
    @@dns::zone { "${::fqdn}_reverse_${reverse}":
      zonetype => 'slave',
      masters  => [ $ip ],
      manage_file => false,
      soaip       => $ip,
      zone        => $reverse
    }
  }

  @@dns::zone { "${::fqdn}_forward_slave":
    zonetype    => 'slave',
    masters     => [ $ip ],
    manage_file => false,
    soaip       => $ip,
    zone        => $foreman_proxy::dns_zone
  }

  Dns::Zone <<| soaip != $ip |>>

}
