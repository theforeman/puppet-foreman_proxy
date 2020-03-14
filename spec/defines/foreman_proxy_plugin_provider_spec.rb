require 'spec_helper'

describe 'foreman_proxy::plugin::provider' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'test' }
      let(:pre_condition) { 'include foreman_proxy::params' }

      context 'with defaults' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_foreman_proxy__plugin('test').with_version('installed').with_package(/[-_]test$/) }
        it { is_expected.to contain_foreman_proxy__provider('test').with_ensure('file').with_template_path('foreman_proxy/plugin/test.yml.erb') }
      end

      context 'with version => absent' do
        let(:params) { { version: 'absent' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_foreman_proxy__plugin('test').with_version('absent') }
        it { is_expected.to contain_foreman_proxy__provider('test').with_ensure('absent') }
      end
    end
  end
end
