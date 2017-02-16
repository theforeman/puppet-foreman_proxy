require 'spec_helper'

describe 'foreman_proxy::proxydns' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      context 'without parameters' do
        let(:facts) do
          facts.merge({
            :ipaddress_eth0 => '192.168.100.1',
            :netmask_eth0   => '255.255.255.0',
          })
        end

        let :pre_condition do
          "class {'foreman_proxy':}"
        end

        it 'should include the dns class' do
          should contain_class('dns').with_forwarders([])
        end

        it 'should install nsupdate' do
          nsupdate_pkg = case facts[:osfamily]
                         when 'RedHat'
                           'bind-utils'
                         when 'FreeBSD', 'DragonFly'
                           'bind910'
                         when 'Archlinux'
                           'bind-tools'
                         else
                           'dnsutils'
                         end
          should contain_package(nsupdate_pkg).with_ensure('present')
        end

        it 'should include the forward zone' do
          should contain_dns__zone('example.com').with_soa('foo.example.com')
          should contain_dns__zone('example.com').with_reverse(false)
          should contain_dns__zone('example.com').with_soaip('192.168.100.1')
        end

        it 'should include the reverse zone' do
          should contain_dns__zone('100.168.192.in-addr.arpa').with_soa('foo.example.com')
          should contain_dns__zone('100.168.192.in-addr.arpa').with_reverse(true)
          should contain_dns__zone('100.168.192.in-addr.arpa').with_soaip('192.168.100.1')
        end
      end

      context 'with dns_zone overridden' do
        let(:facts) do
          facts.merge({
            :ipaddress_eth0 => '192.168.100.1',
            :netmask_eth0   => '255.255.255.0',
          })
        end

        let :pre_condition do
          "class {'foreman_proxy': dns_zone => 'something.example.com' }"
        end

        it 'should include the forward zone' do
          should contain_dns__zone('something.example.com').with_soa('foo.example.com')
          should contain_dns__zone('something.example.com').with_reverse(false)
          should contain_dns__zone('something.example.com').with_soaip('192.168.100.1')
        end
      end

      context "with vlan interface" do
        let :facts do
          facts.merge({
            :ipaddress_eth0_0 => '192.168.100.1',
            :netmask_eth0_0   => '255.255.255.0',
          })
        end

        let :pre_condition do
          "class {'foreman_proxy':
            dns_interface => 'eth0.0'
          }"
        end

        it 'should include the forward zone' do
          should contain_dns__zone('example.com').with_soa('foo.example.com')
          should contain_dns__zone('example.com').with_reverse(false)
          should contain_dns__zone('example.com').with_soaip('192.168.100.1')
        end

        it 'should include the reverse zone' do
          should contain_dns__zone('100.168.192.in-addr.arpa').with_soa('foo.example.com')
          should contain_dns__zone('100.168.192.in-addr.arpa').with_reverse(true)
          should contain_dns__zone('100.168.192.in-addr.arpa').with_soaip('192.168.100.1')
        end
      end

      context "with alias interface" do
        let(:facts) do
          facts.merge({
            :ipaddress_eth0_0 => '192.168.100.1',
            :netmask_eth0_0   => '255.255.255.0',
          })
        end

        let :pre_condition do
          "class {'foreman_proxy':
            dns_interface => 'eth0:0'
          }"
        end

        it 'should include the forward zone' do
          should contain_dns__zone('example.com').with_soa('foo.example.com')
          should contain_dns__zone('example.com').with_reverse(false)
          should contain_dns__zone('example.com').with_soaip('192.168.100.1')
        end

        it 'should include the reverse zone' do
          should contain_dns__zone('100.168.192.in-addr.arpa').with_soa('foo.example.com')
          should contain_dns__zone('100.168.192.in-addr.arpa').with_reverse(true)
          should contain_dns__zone('100.168.192.in-addr.arpa').with_soaip('192.168.100.1')
        end
      end

      context "with dns_reverse value" do
        let(:facts) do
          facts.merge({
            :ipaddress_eth0 => '192.168.100.1',
            :netmask_eth0   => '255.255.255.0',
          })
        end

        let :pre_condition do
          "class {'foreman_proxy':
            dns_reverse => ['168.192.in-addr.arpa']
          }"
        end

        it 'should include the reverse zone 168.192.in-addr.arpa' do
          should contain_dns__zone('168.192.in-addr.arpa').with_soa('foo.example.com')
          should contain_dns__zone('168.192.in-addr.arpa').with_reverse(true)
          should contain_dns__zone('168.192.in-addr.arpa').with_soaip('192.168.100.1')
        end
      end

      context "with dns_reverse array" do
        let(:facts) do
          facts.merge({
            :ipaddress_eth0 => '192.168.100.1',
            :netmask_eth0   => '255.255.255.0',
          })
        end

        let :pre_condition do
          "class {'foreman_proxy':
            dns_reverse => ['0.168.192.in-addr.arpa', '1.168.192.in-addr.arpa']
          }"
        end

        it 'should include the reverse zone 0.168.192.in-addr.arpa' do
          should contain_dns__zone('0.168.192.in-addr.arpa').with_soa('foo.example.com')
          should contain_dns__zone('0.168.192.in-addr.arpa').with_reverse(true)
          should contain_dns__zone('0.168.192.in-addr.arpa').with_soaip('192.168.100.1')
        end

        it 'should include the reverse zone 1.168.192.in-addr.arpa' do
          should contain_dns__zone('1.168.192.in-addr.arpa').with_soa('foo.example.com')
          should contain_dns__zone('1.168.192.in-addr.arpa').with_reverse(true)
          should contain_dns__zone('1.168.192.in-addr.arpa').with_soaip('192.168.100.1')
        end
      end
    end
  end
end
