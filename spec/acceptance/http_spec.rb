require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy with http enabled' do
  before(:context) { purge_foreman_proxy }

  it_behaves_like 'the example', 'http.pp'

  describe service('foreman-proxy') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe port(8000) do
    it { is_expected.to be_listening }
  end

  describe port(8443) do
    it { is_expected.not_to be_listening }
  end
end
