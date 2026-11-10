require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy' do
  before(:context) { purge_foreman_proxy }

  include_examples 'the example', 'basic.pp'

  it_behaves_like 'the default foreman proxy application'

  describe package('foreman-proxy-journald') do
    it { is_expected.not_to be_installed }
  end

  describe command('nmap --script +ssl-enum-ciphers localhost -p 8443') do
    its(:stdout) { should match(/TLSv1\.3/) }
    its(:stdout) { should match(/TLSv1\.2/) }
    its(:stdout) { should_not match(/TLSv1\.1/) }
    its(:stdout) { should_not match(/TLSv1\.0/) }

    # Test that the least cipher strength is "strong" or "A"
    its(:stdout) { should match(/least strength: (A|strong)/) }
  end
end
