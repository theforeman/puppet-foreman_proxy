require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy with remote_execution ssh plugin' do
  before(:context) { purge_installed_packages }

  include_examples 'the example', 'remote_execution_ssh.pp'

  it_behaves_like 'the default foreman proxy application'
end
