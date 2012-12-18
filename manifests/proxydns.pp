class foreman_proxy::proxydns {
  class { dns:
    forwarders => $foreman_proxy::dns_forwarders,
  }

  package { $foreman_proxy::params::nsupdate:
    ensure => installed,
  }

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
}
