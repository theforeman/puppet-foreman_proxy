require 'spec_helper'

describe 'foreman_proxy::get_network_in_addr' do
  it 'should exist' do
    is_expected.not_to eq(nil)
  end

  it 'should throw an error with bad number of arguments' do
    is_expected.to run.with_params().and_raise_error(ArgumentError)
    is_expected.to run.with_params('192.168.1.0').and_raise_error(ArgumentError)
    is_expected.to run.with_params('192.168.1.0', '255.255.255.0', 'additional').and_raise_error(ArgumentError)
  end

  it 'should throw an error on invalid parameters' do
    is_expected.to run.with_params('192.168.1', '255.255.255.0').and_raise_error(Puppet::ParseError)
    is_expected.to run.with_params('2001:db8::1', '255.255.255.0').and_raise_error(Puppet::ParseError)
    is_expected.to run.with_params('192.168.1.0', '32').and_raise_error(Puppet::ParseError)
    is_expected.to run.with_params('192.168.1.0', '2001:db8::1').and_raise_error(Puppet::ParseError)
  end

  it 'should work on IPv4 /8 to /32' do
    data = {
      '1.168.192.in-addr.arpa' => ['255.255.255.0', '255.255.255.128', '255.255.255.192', '255.255.255.224', '255.255.255.240', '255.255.255.248', '255.255.255.252', '255.255.255.254', '255.255.255.255'],
      '168.192.in-addr.arpa' => ['255.255.0.0', '255.255.128.0', '255.255.192.0', '255.255.224.0', '255.255.240.0', '255.255.248.0', '255.255.252.0', '255.255.254.0'],
      '192.in-addr.arpa' => ['255.0.0.0', '255.128.0.0', '255.192.0.0', '255.224.0.0', '255.240.0.0', '255.248.0.0', '255.252.0.0', '255.254.0.0'],
    }
    data.each do |expected, netmasks|
      netmasks.each do |netmask|
        is_expected.to run.with_params('192.168.1.0', netmask).and_return(expected)
      end
    end
  end

  it 'should fail on IPv4 /0 to /7' do
    ['0.0.0.0.0', '128.0.0.0', '192.0.0.0', '224.0.0.0', '240.0.0.0', '248.0.0.0', '252.0.0.0', '254.0.0.0'].each do |netmask|
      is_expected.to run.with_params('192.168.1.0', netmask).and_raise_error(Puppet::ParseError)
    end
  end
end
