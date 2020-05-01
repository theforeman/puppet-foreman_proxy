require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy' do
  before(:context) { purge_installed_packages }

  include_examples 'the example', 'basic.pp'

  it_behaves_like 'the default foreman proxy application'

  describe package('foreman-proxy-journald') do
    it { is_expected.not_to be_installed }
  end
end
