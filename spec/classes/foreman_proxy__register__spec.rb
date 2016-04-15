require 'spec_helper'

describe 'foreman_proxy::register' do
  on_supported_os.each do |os, facts|
    next if only_test_os() and not only_test_os.include?(os)
    next if exclude_test_os() and exclude_test_os.include?(os)
    context "on #{os}" do
      let(:facts) { facts }

      describe 'with default settings' do
        let :pre_condition do
          "include foreman_proxy"
        end

        it 'should install provider dependencies' do
          should contain_class('foreman::providers')
        end

        it 'should register the proxy' do
          should contain_class('foreman_proxy::register')
          should contain_foreman_smartproxy(facts[:fqdn]).with({
            'ensure'          => 'present',
            'base_url'        => "https://#{facts[:fqdn]}",
            'effective_user'  => 'admin',
            'url'             => "https://#{facts[:fqdn]}:8443",
            'consumer_key'    => /\w+/,
            'consumer_secret' => /\w+/,
            'ssl_ca'          => /\A\/.+\.pem\z/,
          })
        end
      end

      describe 'with overrides' do
        let :pre_condition do
          "class {'foreman_proxy':
            register_in_foreman   => true,
            foreman_base_url      => 'my_base',
            registered_name       => 'my_proxy',
            registered_proxy_url  => 'my_url',
            oauth_consumer_key    => 'key',
            oauth_consumer_secret => 'secret',
            oauth_effective_user  => 'smartproxy',
          }"
        end

        it 'should register the proxy' do
          should contain_class('foreman_proxy::register')
          should contain_foreman_smartproxy('my_proxy').with({
            'ensure'          => 'present',
            'base_url'        => 'my_base',
            'effective_user'  => 'smartproxy',
            'url'             => 'my_url',
            'consumer_key'    => 'key',
            'consumer_secret' => 'secret',
          })
        end
      end

      describe 'with ssl_port overrides' do
        let :pre_condition do
          "class {'foreman_proxy':
            register_in_foreman   => true,
            foreman_base_url      => 'my_base',
            registered_name       => 'my_proxy',
            oauth_consumer_key    => 'key',
            oauth_consumer_secret => 'secret',
            oauth_effective_user  => 'smartproxy',
            ssl_port              => '1234',
          }"
        end

        it 'should register the proxy' do
          should contain_class('foreman_proxy::register')
          should contain_foreman_smartproxy('my_proxy').with({
            'ensure'          => 'present',
            'base_url'        => 'my_base',
            'effective_user'  => 'smartproxy',
            'url'             => "https://#{facts[:fqdn]}:1234",
            'consumer_key'    => 'key',
            'consumer_secret' => 'secret',
          })
        end
      end

      describe 'with foreman_ssl_ca override' do
        let :pre_condition do
          "class {'foreman_proxy':
            register_in_foreman => true,
            foreman_ssl_ca      => '/etc/foreman/ssl/ca.pem',
          }"
        end

        it 'should register the proxy' do
          should contain_class('foreman_proxy::register')
          should contain_foreman_smartproxy(facts[:fqdn]).with({
            'ensure' => 'present',
            'ssl_ca' => '/etc/foreman/ssl/ca.pem',
          })
        end
      end

      describe 'with ssl_ca override' do
        let :pre_condition do
          "class {'foreman_proxy':
            register_in_foreman => true,
            ssl_ca              => '/etc/foreman/ssl/ca.pem',
          }"
        end

        it 'should register the proxy' do
          should contain_class('foreman_proxy::register')
          should contain_foreman_smartproxy(facts[:fqdn]).with({
            'ensure' => 'present',
            'ssl_ca' => '/etc/foreman/ssl/ca.pem',
          })
        end
      end

      describe 'disabled' do
        let :pre_condition do
          "class {'foreman_proxy': register_in_foreman => false}"
        end

        it 'should not register the proxy' do
          should contain_class('foreman_proxy::register')
          should_not contain_foreman_smartproxy(facts[:fqdn])
        end
      end
    end
  end
end
