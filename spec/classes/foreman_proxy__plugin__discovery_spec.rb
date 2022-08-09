require 'spec_helper'

describe 'foreman_proxy::plugin::discovery' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:pre_condition) { 'include foreman_proxy' }
      let(:tftproot) do
        case facts[:osfamily]
        when 'Debian'
          '/srv/tftp'
        when 'FreeBSD', 'DragonFly'
          '/tftpboot'
        else
          '/var/lib/tftpboot'
        end
      end
      let(:etc_dir) do
        case facts[:osfamily]
        when 'FreeBSD', 'DragonFly'
          '/usr/local/etc'
        else
          '/etc'
        end
      end
      let(:group) do
        case facts[:osfamily]
        when 'FreeBSD', 'DragonFly'
          'foreman_proxy'
        else
          'foreman-proxy'
        end
      end
      let(:user) { group }

      describe 'without paramaters' do
        it { should compile.with_all_deps }
        it { should contain_foreman_proxy__plugin('discovery') }
        it { should contain_foreman_proxy__feature('Discovery') }
        it { should_not contain_foreman_proxy__remote_file("#{tftproot}/boot/fdi-image-latest.tar") }
        it { should_not contain_exec('untar fdi-image-latest.tar') }

        it do
          is_expected.to contain_file("#{etc_dir}/foreman-proxy/settings.d/discovery.yml").with(
            ensure: 'file',
            owner: 'root',
            group: group,
            mode: '0640',
            content: %r{:enabled: https},
          )
        end
      end

      describe 'with install_images => true' do
        let :params do
          {
            :install_images => true
          }
        end

        it { should compile.with_all_deps }
        it { should contain_foreman_proxy__plugin('discovery') }
        it { should contain_foreman_proxy__feature('Discovery') }

        it 'should download and install tarball' do
          should contain_foreman_proxy__remote_file("#{tftproot}/boot/fdi-image-latest.tar").with(
            remote_location: 'http://downloads.theforeman.org/discovery/releases/latest/fdi-image-latest.tar',
            owner: user,
            group: group,
          )
        end

        it 'should extract the tarball' do
          should contain_exec('untar fdi-image-latest.tar').with({
            'command' => 'tar xf fdi-image-latest.tar',
            'path' => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
            'cwd' => "#{tftproot}/boot",
            'creates' => "#{tftproot}/boot/fdi-image/initrd0.img",
          })
        end
      end
    end
  end
end
