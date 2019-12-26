require 'spec_helper'

describe 'foreman_proxy::plugin::abrt' do
  on_plugin_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include foreman_proxy' }

      describe 'with default settings' do
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

      describe 'with faf_ssl_* set' do
        let :params do {
          :faf_server_ssl_cert => '/faf_cert.pem',
          :faf_server_ssl_key => '/faf_key.pem',
        } end

        it 'should set server_ssl_cert and _key' do
          should contain_file('/etc/foreman-proxy/settings.d/abrt.yml').
            with_content(%r{^:server_ssl_cert:\s+/faf_cert.pem$}).
            with_content(%r{^:server_ssl_key:\s+/faf_key.pem$})
        end
      end
    end
  end
end
