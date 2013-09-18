require 'spec_helper'

describe 'foreman_proxy::proxydns' do

  context 'on RedHat' do
    let :facts do
      {
        :fqdn            => 'localhost',
        :domain          => 'example.org',
        :ipaddress_eth0  => '127.0.1.1',
        :operatingsystem => 'CentOS',
        :osfamily        => 'RedHat',
      }
    end

    context 'without parameters' do
      let :pre_condition do
        "class {'foreman_proxy':}"
      end

      it 'should include the dns class' do
        should contain_class('dns').with({
          :forwarders => [],
        })
      end

      it 'should install nsupdate' do
        should contain_package('bind-utils').with_ensure('installed')
      end

      it 'should include the forward zone' do
        should contain_dns__zone('example.org').with({
          :soa     => facts[:fqdn],
          :reverse => false,
          :soaip   => '127.0.1.1',
        })
      end

      it 'should include the reverse zone' do
        should contain_dns__zone('100.168.192.in-addr.arpa').with({
          :soa     => facts[:fqdn],
          :reverse => true,
          :soaip   => '127.0.1.1',
        })

      end

      context 'with dns_zone overridden' do
        let :pre_condition do
          "class {'foreman_proxy': dns_zone => 'something.example.com' }"
        end

        it 'should include the forward zone' do
          should contain_dns__zone('something.example.com').with({
            :soa     => facts[:fqdn],
            :reverse => false,
            :soaip   => '127.0.1.1',
          })
        end
      end
    end
  end

  context 'on Debian' do
    let :facts do
      {
        :fqdn            => 'localhost',
        :domain          => 'example.org',
        :ipaddress_eth0  => '127.0.1.1',
        :operatingsystem => 'Debian',
        :osfamily        => 'Debian',
      }
    end

    let :pre_condition do
      "class {'foreman_proxy':}"
    end

    it 'should install nsupdate' do
      should contain_package('dnsutils').with_ensure('installed')
    end
  end

end
