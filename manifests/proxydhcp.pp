# Configure the DHCP component
class foreman_proxy::proxydhcp {
  # puppet fact names are converted from ethX.X and ethX:X to ethX_X
  # so for alias and vlan interfaces we have to modify the name accordingly
  $interface_fact_name = regsubst($foreman_proxy::dhcp_interface, '[.:]', '_')
  $ip = pick_default($::foreman_proxy::dhcp_pxeserver, fact("ipaddress_${interface_fact_name}"))
  unless ($ip =~ Stdlib::Compat::Ipv4) {
    fail("Could not get the ip address from fact ipaddress_${interface_fact_name}")
  }

  $net  = fact("network_${interface_fact_name}")
  unless ($net =~ Stdlib::Compat::Ipv4) {
    fail("Could not get the network address from fact network_${interface_fact_name}")
  }

  $mask = fact("netmask_${interface_fact_name}")
  unless ($mask =~ Stdlib::Compat::Ipv4) {
    fail("Could not get the network mask from fact netmask_${interface_fact_name}")
  }

  if $foreman_proxy::dhcp_nameservers == 'default' {
    $nameservers = [$ip]
  } else {
    $nameservers = split($foreman_proxy::dhcp_nameservers,',')
  }

  if $foreman_proxy::dhcp_node_type =~ /^(primary|secondary)$/ {
    $failover = 'dhcp-failover'
  } else {
    $failover = undef
  }

  class { '::dhcp':
    dnsdomain   => $foreman_proxy::dhcp_option_domain,
    nameservers => $nameservers,
    interfaces  => [$foreman_proxy::dhcp_interface] + $foreman_proxy::dhcp_additional_interfaces,
    pxeserver   => $ip,
    pxefilename => 'pxelinux.0',
    omapi_name  => $foreman_proxy::dhcp_key_name,
    omapi_key   => $foreman_proxy::dhcp_key_secret,
  }

  ::dhcp::pool{ $::domain:
    network        => $net,
    mask           => $mask,
    range          => $foreman_proxy::dhcp_range,
    gateway        => $foreman_proxy::dhcp_gateway,
    search_domains => $foreman_proxy::dhcp_search_domains,
    failover       => $failover,
  }


  if $foreman_proxy::dhcp_manage_acls {

    package {'acl':
      ensure => 'installed',
    }

    ['/etc/dhcp', '/var/lib/dhcpd'].each |$path| {
      exec { "Allow ${::foreman_proxy::user} to read ${path}":
        command => "setfacl -R -m u:${::foreman_proxy::user}:rx ${path}",
        path    => '/usr/bin',
        unless  => "getfacl -p ${path} | grep user:${::foreman_proxy::user}:r-x",
        require => Package['acl'],
      }
    }

  }

  if $failover {
    class {'::dhcp::failover':
      peer_address        => $foreman_proxy::dhcp_peer_address,
      role                => $foreman_proxy::dhcp_node_type,
      address             => $foreman_proxy::dhcp_failover_address,
      port                => $foreman_proxy::dhcp_failover_port,
      max_response_delay  => $foreman_proxy::dhcp_max_response_delay,
      max_unacked_updates => $foreman_proxy::dhcp_max_unacked_updates,
      mclt                => $foreman_proxy::dhcp_mclt,
      load_split          => $foreman_proxy::dhcp_load_split,
      load_balance        => $foreman_proxy::dhcp_load_balance,
      omapi_key           => $foreman_proxy::dhcp_key_secret,
    }
  }
}
