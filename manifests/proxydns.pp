class foreman_proxy::proxydns {
  include dns

  $ip_temp = "::ipaddress_${foreman_proxy::dns_interface}"
  $ip      = inline_template('<%= scope.lookupvar(ip_temp) %>')

  dns::zone { $::domain:
    soa     => $::fqdn,
    reverse => false,
    soaip   => $ip,
  }

  dns::zone { $foreman_proxy::dns_reverse:
    soa     => $::fqdn,
    reverse => true,
    soaip   => $ip,
  }

  group {$foreman_proxy::params::dns_group:
    members => 'foreman-proxy',
  }
}
