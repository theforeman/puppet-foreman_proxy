require 'spec_helper'

describe_plugin 'foreman_proxy::plugin::acd' do
  describe 'with default settings' do
    include_examples 'a plugin with a settings file', 'acd' do
      let(:expected_config) { "---\n:enabled: https\n" }
    end
  end
end
