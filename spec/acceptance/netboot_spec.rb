require 'spec_helper_acceptance'

describe 'Scenario: tftp' do
  before(:context) { purge_foreman_proxy }

  include_examples 'the example', 'tftp.pp'

  root = case host_inventory['facter']['os']['family']
         when 'Debian'
           '/srv/tftp'
         else
           '/var/lib/tftpboot'
         end

  describe file("#{root}/grub2/boot") do
    it { should be_symlink }
    it { should be_linked_to '../boot' }
  end

  describe 'ensure tftp client is installed' do
    on hosts, puppet('resource', 'package', 'tftp', 'ensure=installed')
  end

  describe command("echo get /grub2/grub.cfg /tmp/downloaded_file | tftp #{fact('fqdn')}") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should_not contain('Error code') }
  end

  describe file('/tmp/downloaded_file') do
    it { should be_file }
    its(:content) { should match(/This system was not recognized by Foreman/) }
  end
end
