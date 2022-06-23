require 'spec_helper'

describe 'foreman_proxy::proxydns' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        override_facts(facts, networking: {interfaces: {eth0: {
          ip: '192.168.100.1',
          netmask: '255.255.255.0',
        }}})
      end

      context 'with inherited parameters' do
        let(:pre_condition) { 'include foreman_proxy' }

        it { should compile.with_all_deps }

        it 'should inherit the correct parameters' do
          should contain_class('foreman_proxy::proxydns')
            .with_forwarders([])
            .with_interface(facts[:networking]['primary'] || 'eth0')
            .with_forward_zone('example.com')
            .with_reverse_zone(nil)
            .with_soa('foo.example.com')
        end
      end

      context 'with explicit parameters' do
        let :params do
          {
            forwarders: [],
            interface: 'eth0',
            forward_zone: 'example.com',
            reverse_zone: false,
          }
        end

        context 'with eth0' do
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

          context 'with dns_zone overridden' do
            let(:params) { super().merge(forward_zone: 'something.example.com') }

            it 'should include the forward zone' do
              should contain_dns__zone('something.example.com')
                .with_soa('foo.example.com')
                .with_reverse(false)
                .with_soaip('192.168.100.1')
            end
          end

          context "with dns_reverse value" do
            let(:params) { super().merge(reverse_zone: ['168.192.in-addr.arpa']) }

            it 'should include the reverse zone 168.192.in-addr.arpa' do
              should contain_dns__zone('168.192.in-addr.arpa')
                .with_soa('foo.example.com')
                .with_reverse(true)
            end
          end

          context "with dns_reverse array" do
            let(:params) { super().merge(reverse_zone: ['0.168.192.in-addr.arpa', '1.168.192.in-addr.arpa']) }

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

          context 'invalid netmask fact' do
            let(:facts) { override_facts(super(), networking: {interfaces: {eth0: {netmask: '0.0.0.0'}}}) }

            it { should compile.and_raise_error(%r{subnets smaller than /8 are not supported}) }
          end
        end

        context "with vlan interface" do
          let :facts do
            override_facts(super(), networking: {interfaces: {:'eth0.0' => {
              ip: '192.0.2.1',
              netmask: '255.255.255.0',
            }}})
          end

          let(:params) { super().merge(interface: 'eth0.0') }

          it 'should include the forward zone' do
            should contain_dns__zone('example.com')
              .with_soa('foo.example.com')
              .with_reverse(false)
              .with_soaip('192.0.2.1')
          end

          it 'should include the reverse zone' do
            should contain_dns__zone('2.0.192.in-addr.arpa')
              .with_soa('foo.example.com')
              .with_reverse(true)
          end
        end

        context "with alias interface" do
          let :facts do
            override_facts(super(), networking: {interfaces: {:'eth0:0' => {
              ip: '203.0.113.1',
              netmask: '255.255.255.0',
            }}})
          end

          let(:params) { super().merge(interface: 'eth0:0') }

          it 'should include the forward zone' do
            should contain_dns__zone('example.com')
              .with_soa('foo.example.com')
              .with_reverse(false)
              .with_soaip('203.0.113.1')
          end

          it 'should include the reverse zone' do
            should contain_dns__zone('113.0.203.in-addr.arpa')
              .with_soa('foo.example.com')
              .with_reverse(true)
          end
        end

        context 'with invalid interface' do
          let(:params) { super().merge(interface: 'invalid') }

          it { should compile.and_raise_error(/Interface 'invalid' was not found in networking facts/) }

          context 'missing netmask fact' do
            let(:facts) { override_facts(super(), networking: {interfaces: {invalid: {ip: '192.0.2.1'}}}) }

            it { should compile.and_raise_error(/Could not get a valid netmask for 'invalid' from facts: ''/) }
          end
        end
      end
    end
  end
end
