# Get the in-addr.arpa notation for the given IP address and a netmask

require 'ipaddr'

Puppet::Functions.create_function(:'foreman_proxy::get_network_in_addr') do
  dispatch :get_network_in_addr do
    required_param 'Stdlib::IP::Address::V4::Nosubnet', :address
    required_param 'Stdlib::IP::Address::V4::Nosubnet', :netmask
  end

  def get_network_in_addr(address_string, netmask_string)
    address = IPAddr.new(address_string)
    netmask = IPAddr.new(netmask_string)

    # The following gets the bits from the netmask, so it turns /255.255.255.0 into
    # /24. We then get the number of times we need to split. Here we rely on
    # truncation (25 / 8 = 3). We then split 5 - 3 times so we end up with
    # '0.1.168.192.in-addr.arpa'.split(".", 2) = ['0', '1.168.192.in-addr.arpa']
    # The last part is our result.
    bits = netmask.to_i.to_s(2).count("1")

    bits = 31 if bits == 32
    if bits < 8
      raise ArgumentError.new("get_network_in_addr(): subnets smaller than /8 are not supported")
    end

    parts = 5 - (bits / 8)
    return address.reverse.to_s.split(".", parts).last
  end
end
