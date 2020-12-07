require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy with ansible plugin'  do
  before(:context) { purge_installed_packages }

  include_examples 'the example', 'ansible.pp'

  it_behaves_like 'the default foreman proxy application'

  describe package('ansible-runner') do
    it { is_expected.to be_installed }
  end
end
