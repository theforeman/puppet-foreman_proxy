require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy with http enabled' do
  before(:context) do
    case os[:family]
    when /redhat|fedora/
      on default, 'yum -y remove foreman* tfm-*'
    when /debian|ubuntu/
      on default, 'apt-get purge -y foreman*', { :acceptable_exit_codes => [0, 100] }
    end
  end

  let(:pp) do
    <<-EOS
    class { 'foreman_proxy':
      repo                => 'nightly',
      puppet_group        => 'root',
      register_in_foreman => false,
      http                => true,
      ssl                 => false,
    }
    EOS
  end

  it_behaves_like 'a idempotent resource'

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
