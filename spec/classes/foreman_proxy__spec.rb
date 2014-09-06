require 'spec_helper'

describe 'foreman_proxy' do

  let :facts do {
    :osfamily               => 'RedHat',
    :operatingsystem        => 'CentOS',
    :operatingsystemrelease => '6.5',
    :fqdn                   => 'my.host.example.com',
  } end

  it 'should include classes' do
    should contain_class('foreman_proxy::install')
    should contain_class('foreman_proxy::config')
    should contain_class('foreman_proxy::service')
    should contain_class('foreman_proxy::register')
  end

end
