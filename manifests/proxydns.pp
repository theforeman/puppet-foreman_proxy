# @summary Configure the ISC named service
#
# @param forwarders
#   The DNS forwarders to use
#
# @param interface
#   The interface to use for fact determination. By default the IP is used to
#   create an A record in the forward zone and determine the reverse DNS
#   zone(s).
#
# @param forward_zone
#   The forward DNS zone name
#
# @param reverse_zone
#   The reverse DNS zone name
#
# @param soa
#   The hostname to use in the SOA record. Also used to create a forward DNS
#   entry.
#
class foreman_proxy::proxydns(
  $forwarders = $foreman_proxy::dns_forwarders,
  $interface = $foreman_proxy::dns_interface,
  $forward_zone = $foreman_proxy::dns_zone,
  $reverse_zone = $foreman_proxy::dns_reverse,
  String $soa = $facts['networking']['fqdn'],
) {
  class { 'dns':
    forwarders => $forwarders,
  }

  $user_group = $dns::group

  # puppet fact names are converted from ethX.X and ethX:X to ethX_X
  # so for alias and vlan interfaces we have to modify the name accordingly
  $interface_fact_name = regsubst($interface, '[.:]', '_')
  $ip = fact("ipaddress_${interface_fact_name}")
  $ip6 = fact("ipaddress6_${interface_fact_name}")

  unless $ip or $ip6 {
    fail("Could not get a valid IP address from fact ipaddress_${interface_fact_name} ('${ip}') or ipaddress6_${interface_fact_name} ('${ip6}')")
  }

  if $reverse_zone {
    $reverse = $reverse_zone
  } else {
    if $ip {
      $netmask = fact("netmask_${interface_fact_name}")
      unless $netmask =~ Stdlib::IP::Address::V4::Nosubnet {
        fail("Could not get a valid netmask from fact netmask_${interface_fact_name}: '${netmask}'")
      }
      $reverse = foreman_proxy::get_network_in_addr($ip, $netmask)
      unless $reverse =~ String[1] {
        fail("Could not determine reverse for ${ip}/${netmask}")
      }
    } else {
      $reverse = undef
    }
  }

  $update_policy = {
    'rndc-key' => {
      'action'    => 'grant',
      'matchtype' => 'zonesub',
      'rr'        => 'ANY',
    },
  }

  dns::zone { $forward_zone:
    soa           => $soa,
    reverse       => false,
    soaip         => $ip,
    soaipv6       => $ip6,
    update_policy => $update_policy,
  }

  if $reverse {
    dns::zone { $reverse:
      soa           => $soa,
      reverse       => true,
      update_policy => $update_policy,
    }
  }
}
