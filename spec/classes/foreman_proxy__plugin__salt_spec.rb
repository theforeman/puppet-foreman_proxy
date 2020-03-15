require 'spec_helper'

describe 'foreman_proxy::plugin::salt' do
  on_plugin_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include foreman_proxy' }

      describe 'with default settings' do
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
        let :params do {
          :user          => 'example',
          :autosign_file => '/etc/salt/example.conf',
          :api           => true,
          :api_url       => 'http://foreman.example.com',
          :api_auth      => 'ldap',
          :api_username  => 'saltapi',
          :api_password  => 'letmein',
          :saltfile      => '/etc/salt/Saltfile',
        } end

        it 'should change salt.yml parameters' do
          should contain_file('/etc/foreman-proxy/settings.d/salt.yml').
            with_content(/:salt_command_user: example/).
            with_content(/:autosign_file: \/etc\/salt\/example.conf/).
            with_content(/:use_api: true/).
            with_content(/:api_url: http:\/\/foreman.example.com/).
            with_content(/:api_auth: ldap/).
            with_content(/:api_username: saltapi/).
            with_content(/:api_password: letmein/).
            with_content(/:saltfile: \/etc\/salt\/Saltfile/)
        end
      end
    end
  end
end
