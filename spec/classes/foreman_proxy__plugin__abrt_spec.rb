require 'spec_helper'

describe 'foreman_proxy::plugin::abrt' do

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

    it { should contain_foreman_proxy__plugin('abrt') }
    it 'should configure abrt.yml' do
      should contain_file('/etc/foreman-proxy/settings.d/abrt.yml').
        with({
          :ensure  => 'file',
          :owner   => 'root',
          :group   => 'foreman-proxy',
          :mode    => '0640',
          :content => /:enabled: https/
        })
    end
  end

  describe 'with group overridden' do
    let :pre_condition do
      "include foreman_proxy"
    end
    let :params do {
      :group => 'example',
    } end

    it 'should change abrt.yml group' do
      should contain_file('/etc/foreman-proxy/settings.d/abrt.yml').
        with({
          :owner   => 'root',
          :group   => 'example'
        })
    end
  end
end
