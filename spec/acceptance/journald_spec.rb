require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy with journald' do
  before(:context) do
    case os[:family]
    when /redhat|fedora/
      on default, 'yum -y remove foreman* tfm-*'
    when /debian|ubuntu/
      on default, 'apt-get purge -y foreman*', { :acceptable_exit_codes => [0, 100] }
    end
  end

  include_examples 'the example', 'journald.pp'

  describe package('foreman-proxy-journald') do
    it { is_expected.to be_installed }
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

  # Logging to the journal is broken on Travis and EL7 but works in Vagrant VMs
  # and regular docker containers
  describe command('journalctl -u foreman-proxy'), unless: ENV['TRAVIS'] == 'true' && os[:family] == 'redhat' && os[:release] =~ /^7\./ do
    its(:stdout) { is_expected.to match(%r{WEBrick::HTTPServer#start}) }
  end
end
