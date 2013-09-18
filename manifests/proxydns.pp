# Configure the DNS component
class foreman_proxy::proxydns {
  class { 'dns':
    forwarders => $foreman_proxy::dns_forwarders,
  }

  package { $foreman_proxy::params::nsupdate:
    ensure => installed,
  }

  $ip = inline_template("<%= scope.lookupvar('::ipaddress_${foreman_proxy::dns_interface}') %>")

  dns::zone { $foreman_proxy::dns_zone:
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
