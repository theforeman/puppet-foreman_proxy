require 'spec_helper'

describe 'foreman_proxy::plugin::module' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'test' }
      let(:pre_condition) { 'include foreman_proxy::params' }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_foreman_proxy__plugin('test').with_version('installed').with_package(/[-_]test$/) }
      it do
        is_expected.to contain_foreman_proxy__module('test')
          .with_ensure('present')
          .with_enabled(false)
          .with_feature('Test')
          .with_listen_on('https')
          .with_template_path('foreman_proxy/plugin/test.yml.erb')
      end

      context 'with version absent' do
        let(:params) do
          {
            version: 'absent',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_foreman_proxy__plugin('test').with_version('absent') }
        it { is_expected.to contain_foreman_proxy__module('test').with_ensure('absent') }
      end
    end
  end
end
