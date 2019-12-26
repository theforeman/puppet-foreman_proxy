require 'spec_helper'

describe 'foreman_proxy::plugin::dhcp::infoblox' do
  on_plugin_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include foreman_proxy' }

      context 'default parameters' do
        let :params do
          {
            :username   => 'admin',
            :password   => 'infoblox',
          }
        end

        it { should compile.with_all_deps }

        it 'should install the correct plugin' do
          should contain_foreman_proxy__plugin('dhcp_infoblox')
        end

        it 'should contain the correct configuration' do
          verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/dhcp_infoblox.yml', [
            '---',
            ':username: "admin"',
            ':password: "infoblox"',
            ':record_type: "fixedaddress"',
            ':dns_view: "default"',
            ':network_view: "default"',
          ])
        end
      end

      context 'all parameters' do
        let :params do
          {
            :username     => 'admin',
            :password     => 'infoblox',
            :record_type  => 'host',
            :dns_view     => 'non-default',
            :network_view => 'another-non-default',
          }
        end

        it 'should contain the correct configuration' do
          verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/dhcp_infoblox.yml', [
            '---',
            ':username: "admin"',
            ':password: "infoblox"',
            ':record_type: "host"',
            ':dns_view: "non-default"',
            ':network_view: "another-non-default"',
          ])
        end
      end
    end
  end
end
