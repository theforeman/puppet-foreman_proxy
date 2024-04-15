require 'spec_helper'

describe 'foreman_proxy::plugin::container_gateway' do
  on_plugin_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include foreman_proxy' }

      describe 'with default settings' do
        it { should contain_foreman_proxy__plugin__module('container_gateway') }
        it 'container_gateway.yml should contain the correct configuration' do
          expect(get_content(catalogue, '/etc/foreman-proxy/settings.d/container_gateway.yml')).to include("---")
          expect(get_content(catalogue, '/etc/foreman-proxy/settings.d/container_gateway.yml')).to include(":enabled: https")
          expect(get_content(catalogue, '/etc/foreman-proxy/settings.d/container_gateway.yml')).to include(":pulp_endpoint: https://#{facts[:fqdn]}")
          expect(get_content(catalogue, '/etc/foreman-proxy/settings.d/container_gateway.yml')).to include(":sqlite_db_path: /var/lib/foreman-proxy/smart_proxy_container_gateway.db")
          connection_string = get_content(catalogue, '/etc/foreman-proxy/settings.d/container_gateway.yml').find { |str| str.include?("db_connection_string") }
          expect(connection_string.split(/[:@\/]/)[6]).to be_a(String).and have_attributes(length: 32)
        end
      end

      describe 'with overwritten parameters' do
        let :params do {
          :pulp_endpoint => 'https://test.example.com',
          :sqlite_db_path => '/dev/null.db',
          :sqlite_timeout => 12345,
          :database_backend => 'sqlite',
          :postgresql_host => 'test.example.com',
          :postgresql_port => 5432,
          :postgresql_database => 'container_gateway',
          :postgresql_user => 'foreman-proxy',
          :postgresql_password => 'changeme'
        } end

        it 'container_gateway.yml should contain the correct configuration' do
          verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/container_gateway.yml', [
            '---',
            ':enabled: https',
            ':pulp_endpoint: https://test.example.com',
            ':sqlite_db_path: /dev/null.db',
            ':sqlite_timeout: 12345',
            ':db_connection_string: sqlite:///dev/null.db'
          ])
        end
      end
    end
  end
end
