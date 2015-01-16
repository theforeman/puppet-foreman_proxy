require 'spec_helper'

describe 'foreman_proxy::plugin::pulp' do

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

    it { should contain_foreman_proxy__plugin('pulp') }
    it 'should configure pulp.yml' do
      should contain_file('/etc/foreman-proxy/settings.d/pulp.yml').
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

    it 'should change pulp.yml group' do
      should contain_file('/etc/foreman-proxy/settings.d/pulp.yml').
        with({
          :owner   => 'root',
          :group   => 'example'
        })
    end
  end
end
