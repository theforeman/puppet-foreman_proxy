require 'spec_helper'

describe 'foreman_proxy::plugin::dynflow' do
  describe 'with default settings' do
    let :facts do
      on_supported_os['redhat-7-x86_64']
    end

    let :pre_condition do
      "include foreman_proxy"
    end

    it { should contain_foreman_proxy__plugin('dynflow') }
    it 'should configure dynflow.yml' do
      should contain_file('/etc/foreman-proxy/settings.d/dynflow.yml').
        with({
          :ensure  => 'file',
          :owner   => 'root',
          :mode    => '0640',
          :content => /:enabled: https/
        })
    end
  end
end
