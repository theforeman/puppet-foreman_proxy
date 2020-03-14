require 'spec_helper'

describe 'foreman_proxy::plugin::chef' do
  on_plugin_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include foreman_proxy' }

      context 'chef plugin is enabled' do
        let :params do
          {
            :enabled => true
          }
        end

        it { should compile.with_all_deps }

        it 'should call the plugin' do
          should contain_foreman_proxy__plugin('chef')
        end

        it 'should install configuration file' do
          should contain_foreman_proxy__settings_file('chef').with_enabled(true).with_listen_on('https')
          verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/chef.yml', [
            '---',
            ':enabled: https',
            ':chef_authenticate_nodes: true',
            ':chef_server_url: https://foo.example.com',
            ':chef_smartproxy_clientname: foo.example.com',
            ':chef_smartproxy_privatekey: /etc/chef/client.pem',
            ':chef_ssl_verify: true'
          ])
        end
      end

      context 'chef plugin is disabled' do
        let :params do
          {
            :enabled => false
          }
        end

        it { should compile.with_all_deps }

        it 'should call the plugin' do
          should contain_foreman_proxy__plugin('chef')
        end

        it 'should install configuration file' do
          should contain_foreman_proxy__settings_file('chef').with_enabled(false)
          should contain_file('/etc/foreman-proxy/settings.d/chef.yml').with_content(/:enabled: false/)
        end
      end
    end
  end
end
