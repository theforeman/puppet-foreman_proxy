require 'spec_helper'

describe 'foreman_proxy::module' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'test' }
      let(:pre_condition) { 'include foreman_proxy::params' }

      context 'with defaults' do
        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_foreman_proxy__settings_file('test')
            .with_enabled(false)
            .with_feature('TEST')
            .with_listen_on('https')
        end

        it { is_expected.not_to contain_foreman_proxy__feature('TEST') }
      end

      context 'with enabled => true' do
        let(:params) { { enabled: true } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_foreman_proxy__settings_file('test').with_enabled(true) }
        it { is_expected.to contain_foreman_proxy__feature('TEST') }
      end

      context 'with feature' do
        let(:params) { { feature: 'Test' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_foreman_proxy__settings_file('test').with_feature('Test') }
        it { is_expected.not_to contain_foreman_proxy__feature('Test') }

        context 'with enabled => true' do
          let(:params) { super().merge(enabled: true) }

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_foreman_proxy__settings_file('test').with_enabled(true).with_feature('Test') }
          it { is_expected.to contain_foreman_proxy__feature('Test') }
        end
      end

      context 'with listen_on => both' do
        let(:params) { { listen_on: 'both' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_foreman_proxy__settings_file('test').with_listen_on('both') }
      end

      context 'with listen_on => http' do
        let(:params) { { listen_on: 'http' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_foreman_proxy__settings_file('test').with_listen_on('http') }
      end
    end
  end
end
