require 'spec_helper'

describe 'foreman_proxy::plugin::dns::powerdns' do
  on_plugin_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include foreman_proxy' }

      context 'default parameters' do
        it { should compile.with_all_deps }

        it 'should install the correct plugin' do
          should contain_foreman_proxy__plugin('dns_powerdns')
        end

        it 'should contain the correct configuration' do
          verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/dns_powerdns.yml', [
            '---',
            ':powerdns_rest_url: "http://localhost:8081/api/v1/servers/localhost"',
            ':powerdns_rest_api_key: ""',
          ])
        end
      end

      context 'explicit parameters' do
        let :params do
          {
            :rest_url     => 'http://localhost/api',
            :rest_api_key => 'changeme',
          }
        end

        it { should compile.with_all_deps }

        it 'should install the correct plugin' do
          should contain_foreman_proxy__plugin('dns_powerdns')
        end

        it 'should contain the correct configuration' do
          verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/dns_powerdns.yml', [
            '---',
            ':powerdns_rest_url: "http://localhost/api"',
            ':powerdns_rest_api_key: "changeme"',
          ])
        end
      end
    end
  end
end
