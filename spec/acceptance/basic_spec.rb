require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy' do
  before(:context) { purge_installed_packages }

  include_examples 'the example', 'basic.pp'

  describe package('foreman-proxy-journald') do
    it { is_expected.not_to be_installed }
  end

  describe service('foreman-proxy') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe port(8000) do
    it { is_expected.not_to be_listening }
  end

  describe port(8443) do
    it { is_expected.to be_listening }
  end
end
