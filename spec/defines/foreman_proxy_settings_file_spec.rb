require 'spec_helper'

describe 'foreman_proxy::settings_file' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:title) { 'test' }
      let(:config_path) do
        File.join(
          ['FreeBSD', 'DragonFly'].include?(facts[:osfamily]) ? '/usr/local/etc' : '/etc',
          'foreman-proxy', 'settings.d', "#{title}.yml"
        )
      end

      context 'standalone' do
        let(:pre_condition) { 'include foreman_proxy::params' }

        context 'defaults, module enabled' do
          it do
            is_expected.to contain_file(config_path).with(
              ensure: 'file',
              owner: 'root',
              group: ['FreeBSD', 'DragonFly'].include?(facts[:osfamily]) ? 'foreman_proxy' : 'foreman-proxy',
              mode: '0640',
            )
          end

          it 'should set :enabled in config' do
            verify_exact_contents(catalogue, config_path, ['---', ':enabled: https'])
          end

          it { is_expected.not_to contain_foreman_proxy__feature('Test') }
        end

        context 'with feature' do
          let(:params) { { feature: 'Test' } }
          it { is_expected.to contain_foreman_proxy__feature('Test') }
        end

        context 'with listen_on => both' do
          let(:params) { { listen_on: 'both' } }

          it 'should set :enabled to true in config' do
            verify_exact_contents(catalogue, config_path, ['---', ':enabled: true'])
          end
        end

        context 'with listen_on => http' do
          let(:params) { { listen_on: 'http' } }

          it 'should set :enabled to http in config' do
            verify_exact_contents(catalogue, config_path, ['---', ':enabled: http'])
          end
        end

        context 'with enabled => false' do
          let(:params) { { enabled: false } }

          it 'should set :enabled to false in config' do
            verify_exact_contents(catalogue, config_path, ['---', ':enabled: false'])
          end

          context 'with feature' do
            let(:params) { { enabled: false, feature: 'Test' } }
            it { is_expected.not_to contain_foreman_proxy__feature('Test') }
          end
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
