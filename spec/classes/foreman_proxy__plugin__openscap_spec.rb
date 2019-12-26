require 'spec_helper'

describe 'foreman_proxy::plugin::openscap' do
  on_plugin_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include foreman_proxy' }

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
          verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/openscap.yml', [
            '---',
            ':enabled: https',
            ':openscap_send_log_file: /var/log/foreman-proxy/openscap-send.log',
            ':spooldir: /var/spool/foreman-proxy/openscap',
            ':contentdir: /var/lib/foreman-proxy/openscap/content',
            ':reportsdir: /var/lib/foreman-proxy/openscap/reports',
            ':failed_dir: /var/lib/foreman-proxy/openscap/failed',
            ':corrupted_dir: /var/lib/foreman-proxy/openscap/corrupted',
            ':registered_proxy_name: foo.example.com',
            ':registered_proxy_url: https://foo.example.com:8443',
            ':timeout: 60',
          ])
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
          verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/openscap.yml', [
            '---',
            ':enabled: false',
            ':openscap_send_log_file: /var/log/foreman-proxy/openscap-send.log',
            ':spooldir: /var/spool/foreman-proxy/openscap',
            ':contentdir: /var/lib/foreman-proxy/openscap/content',
            ':reportsdir: /var/lib/foreman-proxy/openscap/reports',
            ':failed_dir: /var/lib/foreman-proxy/openscap/failed',
            ':corrupted_dir: /var/lib/foreman-proxy/openscap/corrupted',
            ':registered_proxy_name: foo.example.com',
            ':registered_proxy_url: https://foo.example.com:8443',
            ':timeout: 60',
          ])
        end
      end
    end
  end
end
