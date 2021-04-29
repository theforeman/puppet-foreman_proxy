require 'spec_helper'

describe 'foreman_proxy::tftp' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let :pre_condition do
        'include ::foreman_proxy'
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_class('foreman_proxy::tftp::netboot') }

      case facts[:osfamily]
      when 'Debian'
        tftp_root = if facts[:operatingsystem] == 'Ubuntu'
                      facts[:operatingsystemmajrelease] == '18.04' ? '/var/lib/tftpboot' : '/srv/tftp'
                    else
                      '/srv/tftp'
                    end
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

      it { is_expected.to contain_class('foreman_proxy::tftp::netboot').with_root(tftp_root) }

      case facts[:osfamily]
      when 'FreeBSD', 'DragonFly'
        it { should contain_file("#{tftp_root}/grub2/grub.cfg").with_mode('0644').with_owner('foreman_proxy') }
      else
        it { should contain_file("#{tftp_root}/grub2/grub.cfg").with_mode('0644').with_owner('foreman-proxy') }
      end
    end
  end
end
