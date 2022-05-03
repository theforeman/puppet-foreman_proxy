require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy with remote_execution script plugin'  do
  before(:context) { purge_foreman_proxy }

  include_examples 'the example', 'remote_execution_script.pp'

  it_behaves_like 'the default foreman proxy application'

  describe file('/etc/foreman-proxy/settings.d/remote_execution_ssh.yml') do
    its(:content) { is_expected.to_not match %r{:ssh_log_level:} }
  end
end

describe 'Scenario: install foreman-proxy with remote_execution script plugin and ssh_log_level param' do
  before(:context) { purge_foreman_proxy }

  include_examples 'the example', 'remote_execution_script-ssh_log_level.pp'

  it_behaves_like 'the default foreman proxy application'

  describe file('/etc/foreman-proxy/settings.d/remote_execution_ssh.yml') do
    its(:content) { is_expected.to match %r{:ssh_log_level: debug} }
  end
end
