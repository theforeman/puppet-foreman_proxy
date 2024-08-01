require 'spec_helper'

describe 'foreman_proxy::settings_file' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:title) { 'test' }
      let(:group) { ['FreeBSD', 'DragonFly'].include?(facts[:osfamily]) ? 'foreman_proxy' : 'foreman-proxy' }
      let(:config_path) do
        File.join(
          ['FreeBSD', 'DragonFly'].include?(facts[:osfamily]) ? '/usr/local/etc' : '/etc',
          'foreman-proxy', 'settings.d', "#{title}.yml"
        )
      end

      context 'standalone' do
        let(:pre_condition) { 'include foreman_proxy::params' }

        it do
          is_expected.to compile.with_all_deps
          is_expected.to contain_file(config_path)
            .with_ensure('file')
            .with_owner('root')
            .with_group(group)
            .with_mode('0640')
            .with_content("---\n# Test file only\n# Can be true, false, or http/https to enable just one of the protocols\n:enabled: false\n")
        end

        context 'with ensure => absent' do
          let(:params) do
            {
              ensure: 'absent',
            }
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_file(config_path).with_ensure('absent') }
        end
      end

      context 'with foreman_proxy included' do
        let(:pre_condition) { 'include foreman_proxy' }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file(config_path).that_requires('Class[foreman_proxy::install]').that_notifies('Class[foreman_proxy::service]') }
      end
    end
  end
end
