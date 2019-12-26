require 'spec_helper'

describe 'foreman_proxy::plugin::dns::infoblox' do
  on_plugin_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include foreman_proxy' }

      context 'valid parameters' do
        let :params do
          {
            :dns_server => 'localhost',
            :username   => 'admin',
            :password   => 'infoblox',
            :dns_view   => 'default',
          }
        end

        it { should compile.with_all_deps }

        it 'should install the correct plugin' do
          should contain_foreman_proxy__plugin('dns_infoblox')
        end

        it 'should contain the correct configuration' do
          verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/dns_infoblox.yml', [
            '---',
            ':dns_server: "localhost"',
            ':username: "admin"',
            ':password: "infoblox"',
            ':dns_view: "default"',
          ])
        end
      end
    end
  end
end
