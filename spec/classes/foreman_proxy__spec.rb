require 'spec_helper'

describe 'foreman_proxy' do

  let (:facts) { {
    :osfamily               => 'RedHat',
    :operatingsystem        => 'CentOS',
    :operatingsystemrelease => '6',
    :fqdn                   => 'my.host.example.com',
  } }

  it { should include_class('foreman_proxy::install') }
  it { should include_class('foreman_proxy::config') }
  it { should include_class('foreman_proxy::service') }

  it 'should register the proxy' do
    should include_class('foreman_proxy::register')
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
