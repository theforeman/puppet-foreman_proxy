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
            ":pulp_endpoint: https://#{facts[:networking]['fqdn']}",
            ':sqlite_db_path: /var/lib/foreman-proxy/smart_proxy_container_gateway.db',
            ':db_connection_string: postgres:///container_gateway'
          ])
        end
      end

      describe 'with overwritten postgres parameters' do
        let :params do {
          :pulp_endpoint => 'https://test.example.com',
          :sqlite_db_path => '/dev/null.db',
          :database_backend => 'postgres',
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
            ':db_connection_string: postgres://foreman-proxy:changeme@test.example.com:5432/container_gateway'
          ])
        end
      end

      describe 'with overwritten sqlite parameters' do
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

      describe 'with enabled => false' do
        let(:params) do
          {
            enabled: false,
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_foreman_proxy__plugin__module('container_gateway').with_enabled(false) }
        it { is_expected.not_to contain_class('postgresql::server') }
      end

      describe 'with version => absent' do
        let(:params) do
          {
            version: 'absent',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_foreman_proxy__plugin__module('container_gateway').with_version('absent') }
        it { is_expected.not_to contain_class('postgresql::server') }
      end
    end
  end
end
