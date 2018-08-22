require 'spec_helper'

describe 'foreman_proxy::tftp::netboot' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let :params do
        {:root => '/tftproot'}
      end

      it { is_expected.to compile.with_all_deps }

      it 'should create grub2 boot symlink' do
        should contain_file("/tftproot/grub2/boot").
          with_ensure('link').with_target("../boot")
      end
    end
  end
end
