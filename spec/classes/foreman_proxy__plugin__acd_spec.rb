require 'spec_helper'

describe 'foreman_proxy::plugin::acd' do
  on_plugin_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include foreman_proxy' }

      describe 'with default settings' do
        it { should contain_foreman_proxy__plugin__module('acd') }
        it 'acd.yml should contain the correct configuration' do
          verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/acd.yml', [
            '---',
            ':enabled: https',
          ])
        end
      end
    end
  end
end
