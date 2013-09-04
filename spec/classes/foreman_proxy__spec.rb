require 'spec_helper'

describe 'foreman_proxy' do

  let :facts do {
    :osfamily               => 'RedHat',
    :operatingsystem        => 'CentOS',
    :operatingsystemrelease => '6',
    :fqdn                   => 'my.host.example.com',
  } end

  it 'should include classes' do
    should include_class('foreman_proxy::install')
    should include_class('foreman_proxy::config')
    should include_class('foreman_proxy::service')
    should include_class('foreman_proxy::register')
  end

end
