require 'spec_helper'

describe 'foreman_proxy::plugin::openscap' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      context 'openscap plugin is enabled' do
        let :params do
          {
            :enabled => true
          }
        end

        it 'should call the plugin' do
          should contain_foreman_proxy__plugin('openscap')
        end

        it 'should install configuration file' do
          should contain_foreman_proxy__settings_file('openscap')
          content = catalogue.resource('file', '/etc/foreman-proxy/settings.d/openscap.yml').send(:parameters)[:content]
          content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == [
            '---',
            ':enabled: https',
            ':openscap_send_log_file: /var/log/foreman-proxy/openscap-send.log',
            ":spooldir: /var/spool/foreman-proxy/openscap",
          ]
        end
      end

      context 'openscap plugin is disabled' do
        let :params do
          {
            :enabled => false
          }
        end

        it 'should call the plugin' do
          should contain_foreman_proxy__plugin('openscap')
        end

        it 'should install configuration file' do
          should contain_foreman_proxy__settings_file('openscap')
          content = catalogue.resource('file', '/etc/foreman-proxy/settings.d/openscap.yml').send(:parameters)[:content]
          content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == [
            '---',
            ':enabled: false',
            ':openscap_send_log_file: /var/log/foreman-proxy/openscap-send.log',
            ":spooldir: /var/spool/foreman-proxy/openscap",
          ]
        end
      end
    end
  end
end
