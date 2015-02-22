require 'spec_helper'

describe 'foreman_proxy::plugin::chef' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      context 'chef plugin is enabled' do
        let :params do
          {
            :enabled => true
          }
        end

        it 'should call the plugin' do
          should contain_foreman_proxy__plugin('chef')
        end

        it 'should install configuration file' do
          should contain_foreman_proxy__settings_file('chef')
          should contain_file('/etc/foreman-proxy/settings.d/chef.yml').with_content(/:enabled: true/)
        end
      end

      context 'chef plugin is disabled' do
        let :params do
          {
            :enabled => false
          }
        end

        it 'should call the plugin' do
          should contain_foreman_proxy__plugin('chef')
        end

        it 'should install configuration file' do
          should contain_foreman_proxy__settings_file('chef')
          should contain_file('/etc/foreman-proxy/settings.d/chef.yml').with_content(/:enabled: false/)
        end
      end
    end
  end
end
