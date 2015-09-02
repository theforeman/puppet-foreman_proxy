require 'spec_helper'

describe 'foreman_proxy::plugin::dns::powerdns' do
  let :facts do
    on_supported_os['redhat-7-x86_64']
  end

  let :pre_condition do
    'include ::foreman_proxy'
  end

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
end
