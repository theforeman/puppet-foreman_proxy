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

      if facts[:osfamily] == 'Debian'
        it { should contain_package('grub-common').with_ensure('present') }
        it { should contain_package('grub-efi-amd64-bin').with_ensure('present') }

        it 'should generate efi image from grub2 modules for Debian' do
          should contain_exec('build-grub2-efi-image').with_unless("/bin/grep -q regexp '/tftproot/grub2/grubx64.efi'")
          should contain_file("/tftproot/grub2/grubx64.efi")
            .with_mode('0644')
            .with_owner('root')
            .that_requires('Exec[build-grub2-efi-image]')
        end
        it { should contain_file("/tftproot/grub2/shim.efi").with_ensure('link') }
      elsif facts[:osfamily] == 'RedHat'
        if facts[:operatingsystemmajrelease].to_i > 6
          it { should contain_package('grub2-efi').with_ensure('present') }
          it { should contain_package('grub2-efi-modules').with_ensure('present') }
          it { should contain_package('grub2-tools').with_ensure('present') }
          it { should contain_package('shim').with_ensure('present') }

          case facts[:operatingsystem]
          when /^(RedHat|Scientific|OracleLinux)$/
            it { should contain_file("/tftproot/grub2/grubx64.efi").with_source('/boot/efi/EFI/redhat/grubx64.efi') }
            it { should contain_file("/tftproot/grub2/shim.efi").with_source('/boot/efi/EFI/redhat/shim.efi').with_owner('root').with_mode('0644') }
          when 'Fedora'
            it { should contain_file("/tftproot/grub2/grubx64.efi").with_source('/boot/efi/EFI/fedora/grubx64.efi') }
            it { should contain_file("/tftproot/grub2/shim.efi").with_source('/boot/efi/EFI/fedora/shim.efi').with_owner('root').with_mode('0644') }
          when 'CentOS'
            it { should contain_file("/tftproot/grub2/grubx64.efi").with_source('/boot/efi/EFI/centos/grubx64.efi') }
            it { should contain_file("/tftproot/grub2/shim.efi").with_source('/boot/efi/EFI/centos/shim.efi').with_owner('root').with_mode('0644') }
          end
        else
          it { should contain_package('grub').with_ensure('present') }
          it { should contain_file('/var/lib/tftpboot/grub/grubx64.efi').with_ensure('file').with_owner('root').with_mode('0644').with_source('/boot/efi/EFI/redhat/grub.efi') }
          it { should contain_file('/var/lib/tftpboot/grub/shim.efi').with_ensure('link') }
        end
      else
        # TODO: check if a warning is emited
      end
    end
  end
end
