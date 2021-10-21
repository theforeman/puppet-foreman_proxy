require 'spec_helper'

describe 'foreman_proxy::plugin::reports' do
  on_plugin_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include foreman_proxy' }

      describe 'with default settings' do
        it { should contain_foreman_proxy__plugin__module('reports') }
        it 'should contain the correct configuration in reports.yml' do
          verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/reports.yml', [
            '---',
            ':enabled: https',
            ':reported_proxy_hostname: foo.example.com',
            ':debug_payload: false',
            ':spool_dir: /var/lib/foreman-proxy/reports',
            ':keep_reports: false'
          ])
        end
      end
    end
  end
end
