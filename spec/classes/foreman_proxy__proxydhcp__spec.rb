require 'spec_helper'

describe 'foreman_proxy::proxydhcp' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do

      context "on physical interface" do
        let :facts do
          facts.merge({:ipaddress_eth0 => '127.0.1.1',
                       :netmask_eth0   => '255.0.0.0',
                       :network_eth0   => '127.0.0.0'})
        end

        let :pre_condition do
          "class {'foreman_proxy':
            dhcp_range   => false,
            dhcp_gateway => '127.0.0.254',
          }"
        end

        it do should contain_class('dhcp').with(
          'dnsdomain'   => ['example.com'],
          'nameservers' => ['127.0.1.1'],
          'interfaces'  => ['eth0'],
          'pxeserver'   => '127.0.1.1',
          'pxefilename' => 'pxelinux.0'
        ) end

        it do should contain_dhcp__pool('example.com').with(
          'network' => '127.0.0.0',
          'mask'    => '255.0.0.0',
          'range'   => 'false',
          'gateway' => '127.0.0.254'
        ) end
      end

      context "on vlan interface" do
        let :facts do
          facts.merge({:ipaddress_eth0_0 => '127.0.1.1',
                       :netmask_eth0_0   => '255.0.0.0',
                       :network_eth0_0   => '127.0.0.0'})
        end

        let :pre_condition do
          "class {'foreman_proxy':
            dhcp_range     => false,
            dhcp_gateway   => '127.0.0.254',
            dhcp_interface => 'eth0.0',
          }"
        end

        it do should contain_class('dhcp').with(
          'dnsdomain'   => ['example.com'],
          'nameservers' => ['127.0.1.1'],
          'interfaces'  => ['eth0.0'],
          'pxeserver'   => '127.0.1.1',
          'pxefilename' => 'pxelinux.0'
        ) end

        it do should contain_dhcp__pool('example.com').with(
          'network' => '127.0.0.0',
          'mask'    => '255.0.0.0',
          'range'   => 'false',
          'gateway' => '127.0.0.254'
        ) end
      end

      context "on alias interface" do
        let :facts do
          facts.merge({:ipaddress_eth0_0 => '127.0.1.1',
                       :netmask_eth0_0   => '255.0.0.0',
                       :network_eth0_0   => '127.0.0.0'})
        end

        let :pre_condition do
          "class {'foreman_proxy':
            dhcp_range     => false,
            dhcp_gateway   => '127.0.0.254',
            dhcp_interface => 'eth0:0',
          }"
        end

        it do should contain_class('dhcp').with(
            'dnsdomain'   => ['example.com'],
            'nameservers' => ['127.0.1.1'],
            'interfaces'  => ['eth0:0'],
            'pxeserver'   => '127.0.1.1',
            'pxefilename' => 'pxelinux.0'
        ) end
        it do should contain_dhcp__pool('example.com').with(
            'network' => '127.0.0.0',
            'mask'    => '255.0.0.0',
            'range'   => 'false',
            'gateway' => '127.0.0.254'
        ) end
      end


      context "with dhcp_search_domains" do
        let :facts do
          facts.merge({:ipaddress_eth0 => '127.0.1.1',
                       :netmask_eth0   => '255.0.0.0',
                       :network_eth0   => '127.0.0.0'})
        end

        let :pre_condition do
          "class {'foreman_proxy':
            dhcp_range          => false,
            dhcp_gateway        => '127.0.0.254',
            dhcp_search_domains => ['example.com', 'example.org']
          }"
        end

        it do should contain_dhcp__pool('example.com').with(
            'search_domains' => ['example.com','example.org']
        ) end
      end
    end
  end
end
