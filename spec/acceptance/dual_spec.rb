require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy with http and https enabled' do
  before(:context) { purge_foreman_proxy }

  include_examples 'the example', 'dual.pp'

  describe service('foreman-proxy') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe port(8000) do
    it { is_expected.to be_listening }
  end

  describe port(8443) do
    it { is_expected.to be_listening }
  end
end
