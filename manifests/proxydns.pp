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
class foreman_proxy::proxydns (
  $forwarders = $foreman_proxy::dns_forwarders,
  $interface = $foreman_proxy::dns_interface,
  Stdlib::Fqdn $forward_zone = $foreman_proxy::dns_zone,
  $reverse_zone = $foreman_proxy::dns_reverse,
  String $soa = $facts['networking']['fqdn'],
) {
  class { 'dns':
    forwarders => $forwarders,
  }

  $user_group = $dns::group

  unless 'networking' in $facts {
    fail('Missing modern networking facts')
  }
  unless $interface in $facts['networking']['interfaces'] {
    fail("Interface '${interface}' was not found in networking facts")
  }

  $ip = $facts['networking']['interfaces'][$interface]['ip']
  $ip6 = $facts['networking']['interfaces'][$interface]['ip6']
  unless $ip or $ip6 {
    fail("Could not get a valid IP address for '${interface}' from facts")
  }

  if $reverse_zone {
    $reverse = $reverse_zone
  } else {
    if $ip {
      $netmask = $facts['networking']['interfaces'][$interface]['netmask']
      unless $netmask =~ Stdlib::IP::Address::V4::Nosubnet {
        fail("Could not get a valid netmask for '${interface}' from facts: '${netmask}'")
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
