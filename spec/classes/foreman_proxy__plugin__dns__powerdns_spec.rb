require 'spec_helper'

describe 'foreman_proxy::plugin::dns::powerdns' do
  on_plugin_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include foreman_proxy' }

      context 'default parameters' do
        let :params do
          {
            :mysql_password => 'password',
          }
        end

        it { should compile.with_all_deps }

        it 'should install the correct plugin' do
          should contain_foreman_proxy__plugin('dns_powerdns')
        end

        it 'should contain the correct configuration' do
          verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/dns_powerdns.yml', [
            '---',
            ':powerdns_backend: "mysql"',
            ':powerdns_mysql_hostname: "localhost"',
            ':powerdns_mysql_username: "pdns"',
            ':powerdns_mysql_password: "password"',
            ':powerdns_mysql_database: "pdns"',
            ':powerdns_pdnssec: "pdnssec"',
          ])
        end
      end

      context 'with manage_database => true' do
        let :params do
          {
            :mysql_password  => 'password',
            :manage_database => true,
          }
        end

        it { should compile.with_all_deps }

        it 'should install the correct plugin' do
          should contain_foreman_proxy__plugin('dns_powerdns')
        end

        it 'should contain the correct configuration' do
          verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/dns_powerdns.yml', [
            '---',
            ':powerdns_backend: "mysql"',
            ':powerdns_mysql_hostname: "localhost"',
            ':powerdns_mysql_username: "pdns"',
            ':powerdns_mysql_password: "password"',
            ':powerdns_mysql_database: "pdns"',
            ':powerdns_pdnssec: "pdnssec"',
          ])
        end

        it 'should manage the database' do
          should contain_class('mysql::server')

          should contain_mysql__db('pdns') \
            .with_user('pdns') \
            .with_password('password') \
            .with_host('localhost') \
            .with_grant(['ALL'])
        end
      end

      context 'with backend postgresql' do
        let :params do
          {
            :backend               => 'postgresql',
            :postgresql_connection => 'user=pdns',
            :manage_database       => true,
          }
        end

        it { should compile.with_all_deps }

        it 'should install the correct plugin' do
          should contain_foreman_proxy__plugin('dns_powerdns')
        end

        it 'should contain the correct configuration' do
          verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/dns_powerdns.yml', [
            '---',
            ':powerdns_backend: "postgresql"',
            ':powerdns_postgresql_connection: "user=pdns"',
            ':powerdns_pdnssec: "pdnssec"',
          ])
        end

        it 'should not manage the database' do
          should_not contain_class('mysql::server')
          should_not contain_mysql__db('pdns')
        end
      end

      context 'with backend rest' do
        let :params do
          {
            :backend      => 'rest',
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
            ':powerdns_backend: "rest"',
            ':powerdns_rest_url: "http://localhost/api"',
            ':powerdns_rest_api_key: "changeme"',
          ])
        end

        it 'should not manage the database' do
          should_not contain_class('mysql::server')
          should_not contain_mysql__db('pdns')
        end
      end
    end
  end
end
