require 'spec_helper'

describe 'foreman_proxy::proxydhcp' do

  let :facts do
    {
      :domain                 => 'example.org',
      :ipaddress_eth0         => '127.0.1.1',
      :netmask_eth0           => '255.0.0.0',
      :network_eth0           => '127.0.0.0',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '6',
      :osfamily               => 'RedHat',
    }
  end

  let :pre_condition do
    "class {'foreman_proxy':
      dhcp_range   => false,
      dhcp_gateway => '127.0.0.254',
    }"
  end

  it do should contain_class('dhcp').with(
    'dnsdomain'   => ['example.org'],
    'nameservers' => ['127.0.1.1'],
    'interfaces'  => ['eth0'],
    'pxeserver'   => '127.0.1.1',
    'pxefilename' => 'pxelinux.0'
  ) end

  it do should contain_dhcp__pool('example.org').with(
    'network' => '127.0.0.0',
    'mask'    => '255.0.0.0',
    'range'   => 'false',
    'gateway' => '127.0.0.254'
  ) end

end
