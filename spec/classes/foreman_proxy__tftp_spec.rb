require 'spec_helper'

describe 'foreman_proxy::tftp' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let :pre_condition do
        'include ::foreman_proxy'
      end

      it { is_expected.to compile.with_all_deps }

      tftp_root = case facts[:osfamily]
                  when 'Debian'
                    case facts[:operatingsystem]
                    when 'Ubuntu'
                      '/var/lib/tftpboot'
                    else
                      '/srv/tftp'
                    end
                  when 'FreeBSD', 'DragonFly'
                    '/tftpboot'
                  end

      case facts[:osfamily]
      when 'Archlinux'
        tftp_root = '/srv/tftp'
        names = {
          '/usr/lib/syslinux/bios/pxelinux.0'  => "#{tftp_root}/pxelinux.0",
          '/usr/lib/syslinux/bios/memdisk'     => "#{tftp_root}/memdisk",
          '/usr/lib/syslinux/bios/chain.c32'   => "#{tftp_root}/chain.c32",
          '/usr/lib/syslinux/bios/ldlinux.c32' => "#{tftp_root}/ldlinux.c32",
          '/usr/lib/syslinux/bios/libutil.c32' => "#{tftp_root}/libutil.c32",
          '/usr/lib/syslinux/bios/menu.c32'    => "#{tftp_root}/menu.c32",
        }
      when 'Debian'
        tftp_root = facts[:operatingsystem] == 'Ubuntu' ?  '/var/lib/tftpboot' : '/srv/tftp'
        if facts[:operatingsystem] == 'Ubuntu' && facts[:operatingsystemrelease] == '14.04'
          names = {
            '/usr/lib/syslinux/chain.c32'  => "#{tftp_root}/chain.c32",
            '/usr/lib/syslinux/mboot.c32'  => "#{tftp_root}/mboot.c32",
            '/usr/lib/syslinux/menu.c32'   => "#{tftp_root}/menu.c32",
            '/usr/lib/syslinux/memdisk'    => "#{tftp_root}/memdisk",
            '/usr/lib/syslinux/pxelinux.0' => "#{tftp_root}/pxelinux.0",
          }
        else
          names = {
            '/usr/lib/PXELINUX/pxelinux.0'                => "#{tftp_root}/pxelinux.0",
            '/usr/lib/syslinux/memdisk'                   => "#{tftp_root}/memdisk",
            '/usr/lib/syslinux/modules/bios/chain.c32'    => "#{tftp_root}/chain.c32",
            '/usr/lib/syslinux/modules/bios/ldlinux.c32'  => "#{tftp_root}/ldlinux.c32",
            '/usr/lib/syslinux/modules/bios/libcom32.c32' => "#{tftp_root}/libcom32.c32",
            '/usr/lib/syslinux/modules/bios/libutil.c32'  => "#{tftp_root}/libutil.c32",
            '/usr/lib/syslinux/modules/bios/mboot.c32'    => "#{tftp_root}/mboot.c32",
            '/usr/lib/syslinux/modules/bios/menu.c32'     => "#{tftp_root}/menu.c32",
          }
        end
      when 'FreeBSD', 'DragonFly'
        tftp_root = '/tftpboot'
        names = {
          '/usr/local/share/syslinux/bios/core/pxelinux.0'                   => "#{tftp_root}/pxelinux.0",
          '/usr/local/share/syslinux/bios/memdisk/memdisk'                   => "#{tftp_root}/memdisk",
          '/usr/local/share/syslinux/bios/com32/chain/chain.c32'             => "#{tftp_root}/chain.c32",
          '/usr/local/share/syslinux/bios/com32/elflink/ldlinux/ldlinux.c32' => "#{tftp_root}/ldlinux.c32",
          '/usr/local/share/syslinux/bios/com32/lib/libcom32.c32'            => "#{tftp_root}/libcom32.c32",
          '/usr/local/share/syslinux/bios/com32/libutil/libutil.c32'         => "#{tftp_root}/libutil.c32",
          '/usr/local/share/syslinux/bios/com32/mboot/mboot.c32'             => "#{tftp_root}/mboot.c32",
          '/usr/local/share/syslinux/bios/com32/menu/menu.c32'               => "#{tftp_root}/menu.c32",
        }
      when 'RedHat'
        tftp_root = '/var/lib/tftpboot'
        names = {
          '/usr/share/syslinux/chain.c32'  => "#{tftp_root}/chain.c32",
          '/usr/share/syslinux/mboot.c32'  => "#{tftp_root}/mboot.c32",
          '/usr/share/syslinux/menu.c32'   => "#{tftp_root}/menu.c32",
          '/usr/share/syslinux/memdisk'    => "#{tftp_root}/memdisk",
          '/usr/share/syslinux/pxelinux.0' => "#{tftp_root}/pxelinux.0",
        }
      else
        tftp_root = ''
        names = {}
      end

      names.each do |source, target|
        it { is_expected.to contain_file(target).with_source(source) }
      end

      if facts[:osfamily] == 'Debian'
        it { should contain_package('grub-common').with_ensure('present') }
        it { should contain_package('grub-efi-amd64-bin').with_ensure('present') }

        tftp_root = case facts[:operatingsystem]
                    when 'Ubuntu'
                      '/var/lib/tftpboot'
                    else
                      '/srv/tftp'
                    end
        it 'should generate efi image from grub2 modules for Debian' do
          should contain_exec('build-grub2-efi-image').with_unless("/bin/grep -q regexp '#{tftp_root}/grub2/grubx64.efi'")
          should contain_file("#{tftp_root}/grub2/grubx64.efi")
            .with_mode('0644')
            .with_owner('root')
            .that_requires('Exec[build-grub2-efi-image]')
        end
        it { should contain_file("#{tftp_root}/grub2/shim.efi").with_ensure('link') }
      elsif facts[:osfamily] == 'RedHat'
        if facts[:operatingsystemmajrelease].to_i > 6
          it { should contain_package('grub2-efi').with_ensure('present') }
          it { should contain_package('grub2-efi-modules').with_ensure('present') }
          it { should contain_package('grub2-tools').with_ensure('present') }
          it { should contain_package('shim').with_ensure('present') }

          case facts[:operatingsystem]
          when /^(RedHat|Scientific|OracleLinux)$/
            it { should contain_file("#{tftp_root}/grub2/grubx64.efi").with_source('/boot/efi/EFI/redhat/grubx64.efi') }
            it { should contain_file("#{tftp_root}/grub2/shim.efi").with_source('/boot/efi/EFI/redhat/shim.efi') }
          when 'Fedora'
            it { should contain_file("#{tftp_root}/grub2/grubx64.efi").with_source('/boot/efi/EFI/fedora/grubx64.efi') }
            it { should contain_file("#{tftp_root}/grub2/shim.efi").with_source('/boot/efi/EFI/fedora/shim.efi') }
          when 'CentOS'
            it { should contain_file("#{tftp_root}/grub2/grubx64.efi").with_source('/boot/efi/EFI/centos/grubx64.efi') }
            it { should contain_file("#{tftp_root}/grub2/shim.efi").with_source('/boot/efi/EFI/centos/shim.efi') }
          end
        else
          it { should contain_package('grub').with_ensure('present') }
          it { should contain_file('/var/lib/tftpboot/grub/grubx64.efi').with_ensure('file').with_owner('root').with_mode('0644').with_source('/boot/efi/EFI/redhat/grub.efi') }
          it { should contain_file('/var/lib/tftpboot/grub/shim.efi').with_ensure('link') }
        end
      else
        # TODO: check if a warning is emited
      end

      case facts[:osfamily]
      when 'FreeBSD', 'DragonFly'
        it { should contain_file("#{tftp_root}/grub2/grub.cfg").with_mode('0644').with_owner('foreman_proxy') }
      else
        it { should contain_file("#{tftp_root}/grub2/grub.cfg").with_mode('0644').with_owner('foreman-proxy') }
      end
    end
  end
end
