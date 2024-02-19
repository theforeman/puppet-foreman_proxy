require 'spec_helper'

describe 'foreman_proxy::plugin::hdm' do
  on_plugin_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include foreman_proxy' }
      let(:etc_dir) { '/etc' }
      let(:params) do
        {
          hdm_url: 'http://foreman.betadots.training:3000',
          hdm_user: 'api@domain.tld',
          hdm_password: '1234567890'
        }
      end

      describe 'with default settings' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_foreman_proxy__plugin('hdm') }

        it 'should configure hdm.yml' do
          is_expected.to contain_file("#{etc_dir}/foreman-proxy/settings.d/hdm.yml")
            .with_ensure('file')
            .with_owner('root')
            .with_group('foreman-proxy')

          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/hdm.yml", [
                                  '---',
                                  ':enabled: https',
                                  ":hdm_url: 'http://foreman.betadots.training:3000'",
                                  ":hdm_user: 'api@domain.tld'",
                                  ":hdm_password: '1234567890'"
                                ])
        end
      end
    end
  end
end
