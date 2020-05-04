require 'spec_helper_acceptance'

describe 'Scenario: tftp' do
  before(:context) { purge_installed_packages }

  include_examples 'the example', 'tftp.pp'

  root = fact('os.name') == 'Debian' ? '/srv/tftp' : '/var/lib/tftpboot'

  describe file("#{root}/grub2/boot") do
    it { should be_symlink }
    it { should be_linked_to '../boot' }
  end

  describe 'ensure tftp client is installed' do
    on hosts, puppet('resource', 'package', 'tftp', 'ensure=installed')
  end

  describe command("echo get /grub2/grub.cfg /tmp/downloaded_file | tftp #{fact('fqdn')}") do
    its(:exit_status) { should eq 0 }
  end

  describe file('/tmp/downloaded_file') do
    it { should be_file }
    its(:content) { should match(/This file was deployed by Puppet and is under Smart Proxy control/) }
  end
end
