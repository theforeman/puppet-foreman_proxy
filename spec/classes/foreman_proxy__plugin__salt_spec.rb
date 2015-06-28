require 'spec_helper'

describe 'foreman_proxy::plugin::salt' do

  let :facts do
    on_supported_os['redhat-6-x86_64']
  end

  describe 'with default settings' do
    let :pre_condition do
      "include foreman_proxy"
    end

    it { should contain_foreman_proxy__plugin('salt') }
    it 'should configure salt.yml' do
      should contain_file('/etc/foreman-proxy/settings.d/salt.yml').
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
      :user          => 'example',
      :autosign_file => '/etc/salt/example.conf',
      :api           => true,
      :api_url       => 'http://foreman.example.com',
      :api_auth      => 'ldap',
      :api_username  => 'saltapi',
      :api_password  => 'letmein',
    } end

    it 'should change salt.yml parameters' do
      should contain_file('/etc/foreman-proxy/settings.d/salt.yml').
        with_content(/:salt_command_user: example/).
        with_content(/:autosign_file: \/etc\/salt\/example.conf/).
        with_content(/:use_api: true/).
        with_content(/:api_url: http:\/\/foreman.example.com/).
        with_content(/:api_auth: ldap/).
        with_content(/:api_username: saltapi/).
        with_content(/:api_password: letmein/)
    end
  end

  describe 'with group overridden' do
    let :pre_condition do
      "include foreman_proxy"
    end
    let :params do {
      :group => 'example',
    } end

    it 'should change salt.yml group' do
      should contain_file('/etc/foreman-proxy/settings.d/salt.yml').
        with({
          :owner   => 'root',
          :group   => 'example'
        })
    end
  end
end
