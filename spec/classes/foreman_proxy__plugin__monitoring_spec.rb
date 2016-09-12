require 'spec_helper'

describe 'foreman_proxy::plugin::monitoring' do

  let :facts do
    on_supported_os['redhat-6-x86_64']
  end

  describe 'with default settings' do
    let :pre_condition do
      "include foreman_proxy"
    end

    it { should contain_foreman_proxy__plugin('monitoring') }
    it 'should configure monitoring.yml' do
      should contain_file('/etc/foreman-proxy/settings.d/monitoring.yml').
        with({
          :ensure  => 'file',
          :owner   => 'root',
          :group   => 'foreman-proxy',
          :mode    => '0640',
          :content => /:enabled: https/
        })
    end
  end

  describe 'with overwritten parameters' do
    let :pre_condition do
      "include foreman_proxy"
    end
    let :params do {
      :provider => 'example',
    } end

    it 'should change monitoring.yml parameters' do
      should contain_file('/etc/foreman-proxy/settings.d/monitoring.yml').
        with_content(/:use_provider: monitoring_example/)
    end
  end

  describe 'with group overridden' do
    let :pre_condition do
      "include foreman_proxy"
    end
    let :params do {
      :group => 'example',
    } end

    it 'should change monitoring.yml group' do
      should contain_file('/etc/foreman-proxy/settings.d/monitoring.yml').
        with({
          :owner   => 'root',
          :group   => 'example'
        })
    end
  end
end
