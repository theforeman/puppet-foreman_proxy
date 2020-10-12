# @summary Configure the ISC DHCP service
# @api private
class foreman_proxy::proxydhcp {
  # puppet fact names are converted from ethX.X and ethX:X to ethX_X
  # so for alias and vlan interfaces we have to modify the name accordingly
  $interface_fact_name = regsubst($foreman_proxy::dhcp_interface, '[.:]', '_')
  $ip = pick_default($foreman_proxy::dhcp_pxeserver, fact("ipaddress_${interface_fact_name}"))
  unless ($ip =~ Stdlib::Compat::Ipv4) {
    fail("Could not get the ip address from fact ipaddress_${interface_fact_name}")
  }

  $net  = pick_default($foreman_proxy::dhcp_network, fact("network_${interface_fact_name}"))
  unless ($net =~ Stdlib::Compat::Ipv4) {
    fail("Could not get the network address from fact network_${interface_fact_name}")
  }

  $mask = pick_default($foreman_proxy::dhcp_netmask, fact("netmask_${interface_fact_name}"))
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

  if $foreman_proxy::dhcp_manage_acls {
    $conf_dir_mode = '0750'
  } else {
    # CVE-2020-14335 - if there is a DHCP omapi key set, it may end up being world readable
    case $facts['os']['family'] {
      'RedHat': {
        warning('support for dhcp without acls is deprecated, dhcp config may end up unreadable to the smart-proxy')
      }
      'Debian': {
        warning('support for dhcp without acls is deprecated, your dhcp OMAPI key may end up world readable')
      }
      default: {}
    }
    $conf_dir_mode = undef
  }

  class { 'dhcp':
    dnsdomain     => $foreman_proxy::dhcp_option_domain,
    nameservers   => $nameservers,
    interfaces    => [$foreman_proxy::dhcp_interface] + $foreman_proxy::dhcp_additional_interfaces,
    pxeserver     => $ip,
    pxefilename   => $foreman_proxy::dhcp_pxefilename,
    omapi_name    => $foreman_proxy::dhcp_key_name,
    omapi_key     => $foreman_proxy::dhcp_key_secret,
    conf_dir_mode => $conf_dir_mode,
  }

  ::dhcp::pool{ $facts['networking']['domain']:
    network        => $net,
    mask           => $mask,
    range          => $foreman_proxy::dhcp_range,
    gateway        => $foreman_proxy::dhcp_gateway,
    search_domains => $foreman_proxy::dhcp_search_domains,
    failover       => $failover,
  }


  if $foreman_proxy::dhcp_manage_acls {

    ensure_packages(['grep', 'acl'])

    exec { "Allow ${foreman_proxy::user} to read ${dhcp::dhcp_dir}":
      command => "setfacl -m u:${foreman_proxy::user}:rx ${dhcp::dhcp_dir}",
      path    => ['/bin', '/usr/bin'],
      unless  => "getfacl -p ${dhcp::dhcp_dir} | grep user:${foreman_proxy::user}:r-x",
      require => [Class['dhcp'], Package['acl']],
    }
  }

  if $failover {
    class {'dhcp::failover':
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

  if $foreman_proxy::httpboot {
    if $foreman_proxy::http {
      $proxy_base_url = "http://${ip}:${foreman_proxy::http_port}"
    } else {
      $proxy_base_url = "https://${ip}:${foreman_proxy::https_port}"
    }

    dhcp::dhcp_class { 'httpclients':
      parameters => template('foreman_proxy/httpboot_dhcp_class.erb'),
    }
  }
}
