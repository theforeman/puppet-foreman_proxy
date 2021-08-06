require 'spec_helper'

describe 'foreman_proxy::plugin::acd' do
  on_plugin_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include foreman_proxy' }

      describe 'with default settings' do
        include_examples 'a plugin with a settings file', 'acd' do
          let(:expected_config) { "---\n:enabled: https\n" }
        end
      end
    end
  end
end
