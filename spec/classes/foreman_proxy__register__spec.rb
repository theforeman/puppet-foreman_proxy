require 'spec_helper'

describe 'foreman_proxy::register' do

  let :facts do {
    :osfamily               => 'RedHat',
    :operatingsystem        => 'CentOS',
    :operatingsystemrelease => '6.5',
    :fqdn                   => 'my.host.example.com',
  } end

  describe 'with default settings' do
    let :pre_condition do
      "include foreman_proxy"
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
