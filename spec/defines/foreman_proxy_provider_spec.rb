require 'spec_helper'

describe 'foreman_proxy::provider' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'test' }
      let(:pre_condition) { 'include foreman_proxy::params' }

      context 'with defaults' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_foreman_proxy__settings_file('test').with_ensure('file') }
      end

      context 'with ensure => absent' do
        let(:params) { { ensure: 'absent' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_foreman_proxy__settings_file('test').with_ensure('absent') }
      end
    end
  end
end
