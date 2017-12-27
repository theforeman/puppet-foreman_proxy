# Get the in-addr.arpa notation for the given IP address and a netmask

require 'ipaddr'

Puppet::Functions.create_function(:'foreman_proxy::get_network_in_addr') do
  dispatch :get_network_in_addr do
    required_param 'String', :addr
    required_param 'String', :netm
  end

  def get_network_in_addr(addr, netm)
    begin
      address = IPAddr.new(addr)
    rescue
      raise Puppet::ParseError.new("get_network_in_addr(): address is not a valid IPv4 address")
    end

    begin
      netmask = IPAddr.new(netm)
    rescue
      raise Puppet::ParseError.new("get_network_in_addr(): netmask is not a valid IPv4 address")
    end

    unless address.ipv4? and netmask.ipv4?
      raise Puppet::ParseError.new("get_network_in_addr(): only IPv4 is supported")
    end

    # The following gets the bits from the netmask, so it turns /255.255.255.0 into
    # /24. We then get the number of times we need to split. Here we rely on
    # truncation (25 / 8 = 3). We then split 5 - 3 times so we end up with
    # '0.1.168.192.in-addr.arpa'.split(".", 2) = ['0', '1.168.192.in-addr.arpa']
    # The last part is our result.
    bits = netmask.to_i.to_s(2).count("1")

    bits = 31 if bits == 32
    if bits < 8
      raise Puppet::ParseError.new("get_network_in_addr(): subnets smaller than /8 are not supported")
    end

    parts = 5 - (bits / 8)
    return address.reverse.to_s.split(".", parts).last
  end
end
