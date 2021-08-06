require 'spec_helper'

describe 'foreman_proxy::plugin::container_gateway' do
  on_plugin_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include foreman_proxy' }

      describe 'with default settings' do
        it { should contain_foreman_proxy__plugin__module('container_gateway') }
        it 'container_gateway.yml should contain the correct configuration' do
          verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/container_gateway.yml', [
            '---',
            ':enabled: https',
            ":pulp_endpoint: https://#{facts[:fqdn]}",
            ':sqlite_db_path: /var/lib/foreman-proxy/smart_proxy_container_gateway.db'
          ])
        end
      end

      describe 'with overwritten parameters' do
        let :params do {
          :pulp_endpoint => 'https://test.example.com',
          :sqlite_db_path => '/dev/null.db',
        } end

        it 'container_gateway.yml should contain the correct configuration' do
          verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/container_gateway.yml', [
            '---',
            ':enabled: https',
            ':pulp_endpoint: https://test.example.com',
            ':sqlite_db_path: /dev/null.db'
          ])
        end
      end
    end
  end
end
