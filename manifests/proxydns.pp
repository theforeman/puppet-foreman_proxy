class foreman_proxy::proxydns {
  include foreman_proxy::params
  include dns

  dns::zone { "${::domain}":
    soa     => "${::fqdn}",
    reverse => "false",
    soaip   => "${::ipaddress}",
  }

  dns::zone { "100.168.192.in-addr.arpa":
    soa     => "${::fqdn}",
    reverse => "true",
    soaip   => "${::ipaddress}",
  }
}
