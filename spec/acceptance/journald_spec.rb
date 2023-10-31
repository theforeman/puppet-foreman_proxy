require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy with journald' do
  before(:context) { purge_foreman_proxy }

  include_examples 'the example', 'journald.pp'

  it_behaves_like 'the default foreman proxy application'

  describe package('foreman-proxy-journald') do
    it { is_expected.to be_installed }
  end

  describe command('journalctl -u foreman-proxy') do
    its(:stdout) { is_expected.to match(%r{WEBrick::HTTPServer#start}) }
  end
end
