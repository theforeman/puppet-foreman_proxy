# Configure the DNS component
#
# $nsupdate:: The nsupdate package name
#
# $ensure_packages_version:: The ensure to use on the nsupdate package
#
# $forwarders:: The DNS forwarders to use
#
# $interface:: The interface to use for fact determination. By default the IP
#              is used to create an A record in the forward zone and determine
#              the reverse DNS zone(s).
#
# $forward_zone:: The forward DNS zone name
#
# $reverse_zone:: The reverse DNS zone name
#
# $soa:: The hostname to use in the SOA record. Also used to create a forward
#        DNS entry.
#
class foreman_proxy::proxydns(
  $nsupdate = $::foreman_proxy::nsupdate,
  $ensure_packages_version = $::foreman_proxy::ensure_packages_version,
  $forwarders = $::foreman_proxy::dns_forwarders,
  $interface = $::foreman_proxy::dns_interface,
  $forward_zone = $::foreman_proxy::dns_zone,
  $reverse_zone = $::foreman_proxy::dns_reverse,
  String $soa = $::fqdn,
) {
  class { '::dns':
    forwarders => $forwarders,
  }

  ensure_packages([$nsupdate], { ensure => $ensure_packages_version, })

  # puppet fact names are converted from ethX.X and ethX:X to ethX_X
  # so for alias and vlan interfaces we have to modify the name accordingly
  $interface_fact_name = regsubst($interface, '[.:]', '_')
  $ip = getvar("::ipaddress_${interface_fact_name}")

  unless is_ip_address($ip) {
    fail("Could not get the ip address from fact ipaddress_${interface_fact_name}")
  }

  if $reverse_zone {
    $reverse = $reverse_zone
  } else {
    $netmask = getvar("::netmask_${interface_fact_name}")
    unless is_ip_address($netmask) {
      fail("Could not get the netmask from fact netmask_${interface_fact_name}")
    }
    $reverse = foreman_proxy::get_network_in_addr($ip, $netmask)
    assert_type(String[1], $reverse) |$expected, $actual| {
      fail("Could not determine reverse for ${ip}/${netmask}")
    }
  }

  dns::zone { $forward_zone:
    soa     => $soa,
    reverse => false,
    soaip   => $ip,
  }

  dns::zone { $reverse:
    soa     => $soa,
    reverse => true,
  }
}
