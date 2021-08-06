require 'spec_helper'

describe 'foreman_proxy::plugin::container_gateway' do
  on_plugin_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include foreman_proxy' }

      describe 'with default settings' do
        include_examples 'a plugin with a settings file', 'container_gateway' do
          let(:expected_config) do
            <<~CONFIG
            ---
            # Container Gateway for Katello
            :enabled: https
            :pulp_endpoint: https://#{facts[:fqdn]}
            :sqlite_db_path: /var/lib/foreman-proxy/smart_proxy_container_gateway.db
            CONFIG
          end
        end
      end

      describe 'with overwritten parameters' do
        let :params do {
          :pulp_endpoint => 'https://test.example.com',
          :sqlite_db_path => '/dev/null.db',
        } end

        include_examples 'a plugin with a settings file', 'container_gateway' do
          let(:expected_config) do
            <<~CONFIG
            ---
            # Container Gateway for Katello
            :enabled: https
            :pulp_endpoint: https://test.example.com
            :sqlite_db_path: /dev/null.db
            CONFIG
          end
        end
      end
    end
  end
end
