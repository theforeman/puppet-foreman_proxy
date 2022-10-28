require 'spec_helper'

describe 'foreman_proxy::module' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'test' }
      let(:pre_condition) { 'include foreman_proxy::params' }

      context 'with defaults' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_foreman_proxy__settings_file('test').with_module_enabled('false') }
        it { is_expected.not_to contain_foreman_proxy__feature('Test') }
      end

      context 'with enabled => true' do
        let(:params) { { enabled: true } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_foreman_proxy__settings_file('test').with_module_enabled('https') }
        it { is_expected.to contain_foreman_proxy__feature('Test') }

        context 'with listen_on => both' do
          let(:params) { super().merge(listen_on: 'both') }

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_foreman_proxy__settings_file('test').with_module_enabled('true') }
        end

        context 'with listen_on => http' do
          let(:params) { super().merge(listen_on: 'http') }

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_foreman_proxy__settings_file('test').with_module_enabled('http') }
        end
      end

      context 'with feature' do
        let(:params) { { feature: 'TEST' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_foreman_proxy__feature('TEST') }

        context 'with enabled => true' do
          let(:params) { super().merge(enabled: true) }

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_foreman_proxy__feature('TEST') }
        end
      end
    end
  end
end
