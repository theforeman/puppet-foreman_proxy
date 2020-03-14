require 'spec_helper'

describe 'foreman_proxy::plugin::omaha' do
  on_plugin_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include foreman_proxy' }

      describe 'with default settings' do
        it { should contain_foreman_proxy__plugin__module('omaha') }
        it 'omaha.yml should contain the correct configuration' do
          verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/omaha.yml', [
            '---',
            ':enabled: https',
            ":contentpath: '/var/lib/foreman-proxy/omaha/content'",
            ':sync_releases: 2'
          ])
        end
      end

      describe 'with overwritten parameters' do
        let :params do {
          :contentpath => '/tmp',
          :sync_releases => 5,
          :http_proxy => 'http://myproxy.example.com:8000/',
        } end

        it 'omaha.yml should contain the correct configuration' do
          verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/omaha.yml', [
            '---',
            ':enabled: https',
            ":contentpath: '/tmp'",
            ':sync_releases: 5',
            ":proxy: 'http://myproxy.example.com:8000/'",
          ])
        end
      end
    end
  end
end
