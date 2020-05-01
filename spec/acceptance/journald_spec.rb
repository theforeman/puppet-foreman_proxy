require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy with journald' do
  before(:context) { purge_installed_packages }

  include_examples 'the example', 'journald.pp'

  it_behaves_like 'the default foreman proxy application'

  describe package('foreman-proxy-journald') do
    it { is_expected.to be_installed }
  end

  # Logging to the journal is broken on Travis and EL7 but works in Vagrant VMs
  # and regular docker containers
  describe command('journalctl -u foreman-proxy'), unless: ENV['TRAVIS'] == 'true' && os[:family] == 'redhat' && os[:release] =~ /^7\./ do
    its(:stdout) { is_expected.to match(%r{WEBrick::HTTPServer#start}) }
  end
end
