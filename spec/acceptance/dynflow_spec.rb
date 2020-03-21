require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy', unless: ENV['BEAKER_HYPERVISOR'] == 'docker'  do
  before(:context) do
    case os[:family]
    when /redhat|fedora/
      on default, 'yum -y remove foreman* tfm-*'
    when /debian|ubuntu/
      on default, 'apt-get purge -y foreman*', { :acceptable_exit_codes => [0, 100] }
    end
  end

  include_examples 'the example', 'dynflow.pp'

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


  if os[:family] =~ /redhat|fedora/
    describe service('smart_proxy_dynflow_core') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe port(8008) do
      it { is_expected.to be_listening }
    end
  else
    describe service('smart_proxy_dynflow_core') do
      it { is_expected.not_to be_enabled }
      it { is_expected.not_to be_running }
    end

    describe port(8008) do
      it { is_expected.not_to be_listening }
    end
  end
end
