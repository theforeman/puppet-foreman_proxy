require 'spec_helper_acceptance'

describe 'Scenario: install foreman-proxy with HTTPBoot' do
  include_examples 'the example', 'httpboot.pp'

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

  describe command('curl --silent --write-out \'%{http_code}\' --output /dev/null http://localhost:8000/EFI/grub2/shim.efi') do
    its(:stdout) { should eq('200') }
    its(:exit_status) { should eq 0 }
  end

  describe file('/etc/dhcp/dhcpd.conf') do
    it { should be_file }
    its(:content) { should match(/class "httpclients" {/) }
    its(:content) { should match(%r{filename "http://\d+\.\d+\.\d+\.\d+:8000/EFI/grub2/shim.efi";}) }
  end
end
