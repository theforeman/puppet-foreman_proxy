require 'spec_helper'

describe 'foreman_proxy::plugin::logs' do

  describe 'with default settings' do
    let :pre_condition do
      "include foreman_proxy"
    end

    it { should contain_foreman_proxy__plugin('logs') }
    it 'should configure logs.yml' do
      should contain_file('/etc/foreman-proxy/settings.d/logs.yml').
        with({
          :ensure  => 'file',
          :owner   => 'root',
          :group   => 'foreman-proxy',
          :mode    => '0640',
          :content => /:enabled: https/
        })
    end
  end
end
