require 'spec_helper'

describe 'foreman_proxy::proxydns' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      context 'with inherited parameters' do
        let :facts do
          facts.merge(
            :ipaddress_eth0 => '192.168.100.1',
            :netmask_eth0   => '255.255.255.0',
          )
        end

        let :pre_condition do
          'include ::foreman_proxy'
        end

        it { should compile.with_all_deps }

        it 'should inherit the correct parameters' do
          should contain_class('foreman_proxy::proxydns')
            .with_forwarders([])
            .with_interface('eth0')
            .with_forward_zone('example.com')
            .with_reverse_zone(nil)
            .with_soa('foo.example.com')
        end
      end

      context 'with explicit parameters' do
        let :base_params do
          {
            forwarders: [],
            interface: 'eth0',
            forward_zone: 'example.com',
            reverse_zone: false,
          }
        end

        context 'with base parameters' do
          let :facts do
            facts.merge(
              :ipaddress_eth0 => '192.168.100.1',
              :netmask_eth0   => '255.255.255.0',
            )
          end

          let :params do
            base_params
          end

          it { should compile.with_all_deps }

          it 'should include the dns class' do
            should contain_class('dns').with_forwarders([])
          end

          it 'should include the forward zone' do
            should contain_dns__zone('example.com')
              .with_soa('foo.example.com')
              .with_reverse(false)
              .with_soaip('192.168.100.1')
          end

          it 'should include the reverse zone' do
            should contain_dns__zone('100.168.192.in-addr.arpa')
              .with_soa('foo.example.com')
              .with_reverse(true)
          end
        end

        context 'with dns_zone overridden' do
          let :facts do
            facts.merge(
              :ipaddress_eth0 => '192.168.100.1',
              :netmask_eth0   => '255.255.255.0',
            )
          end

          let :params do
            base_params.merge(:forward_zone => 'something.example.com')
          end

          it 'should include the forward zone' do
            should contain_dns__zone('something.example.com')
              .with_soa('foo.example.com')
              .with_reverse(false)
              .with_soaip('192.168.100.1')
          end
        end

        context "with vlan interface" do
          let :facts do
            facts.merge(
              :ipaddress_eth0_0 => '192.168.100.1',
              :netmask_eth0_0   => '255.255.255.0',
            )
          end

          let :params do
            base_params.merge(:interface => 'eth0:0')
          end

          it 'should include the forward zone' do
            should contain_dns__zone('example.com')
              .with_soa('foo.example.com')
              .with_reverse(false)
              .with_soaip('192.168.100.1')
          end

          it 'should include the reverse zone' do
            should contain_dns__zone('100.168.192.in-addr.arpa')
              .with_soa('foo.example.com')
              .with_reverse(true)
          end
        end

        context "with alias interface" do
          let :facts do
            facts.merge(
              :ipaddress_eth0_0 => '192.168.100.1',
              :netmask_eth0_0   => '255.255.255.0',
            )
          end

          let :params do
            base_params.merge(:interface => 'eth0:0')
          end

          it 'should include the forward zone' do
            should contain_dns__zone('example.com')
              .with_soa('foo.example.com')
              .with_reverse(false)
              .with_soaip('192.168.100.1')
          end

          it 'should include the reverse zone' do
            should contain_dns__zone('100.168.192.in-addr.arpa')
              .with_soa('foo.example.com')
              .with_reverse(true)
          end
        end

        context 'with invalid interface' do
          let :facts do
            facts
          end

          let :params do
            base_params.merge(:interface => 'invalid')
          end

          it { should raise_error(Puppet::Error, /Could not get a valid IP address from fact ipaddress_invalid: '' \(Undef\)/) }
        end

        context "with dns_reverse value" do
          let :facts do
            facts.merge(
              :ipaddress_eth0 => '192.168.100.1',
              :netmask_eth0   => '255.255.255.0',
            )
          end

          let :params do
            base_params.merge(:reverse_zone => ['168.192.in-addr.arpa'])
          end

          it 'should include the reverse zone 168.192.in-addr.arpa' do
            should contain_dns__zone('168.192.in-addr.arpa')
              .with_soa('foo.example.com')
              .with_reverse(true)
          end
        end

        context "with dns_reverse array" do
          let :facts do
            facts.merge(
              :ipaddress_eth0 => '192.168.100.1',
              :netmask_eth0   => '255.255.255.0',
            )
          end

          let :params do
            base_params.merge(:reverse_zone => ['0.168.192.in-addr.arpa', '1.168.192.in-addr.arpa'])
          end

          it 'should include the reverse zone 0.168.192.in-addr.arpa' do
            should contain_dns__zone('0.168.192.in-addr.arpa')
              .with_soa('foo.example.com')
              .with_reverse(true)
          end

          it 'should include the reverse zone 1.168.192.in-addr.arpa' do
            should contain_dns__zone('1.168.192.in-addr.arpa')
              .with_soa('foo.example.com')
              .with_reverse(true)
          end
        end

        context 'with an invalid reverse' do
          context 'missing netmask fact' do
            let :facts do
              facts.merge(ipaddress_invalid: '192.0.2.1')
            end

            let :params do
              base_params.merge(:interface => 'invalid')
            end

            it { should raise_error(Puppet::Error, /Could not get a valid netmask from fact netmask_invalid: '' \(Undef\)/) }
          end

          context 'invalid netmask fact' do
            let :facts do
              facts.merge(
                :ipaddress_eth0 => '192.168.100.1',
                :netmask_eth0   => '0.0.0.0',
              )
            end

            let :params do
              base_params.merge(:interface => 'eth0')
            end

            it { should raise_error(Puppet::Error) }
          end
        end
      end
    end
  end
end
