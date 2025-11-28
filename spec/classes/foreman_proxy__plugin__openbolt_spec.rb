require 'spec_helper'

describe 'foreman_proxy::plugin::openbolt' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include foreman_proxy' }
      let(:etc_dir) { '/etc' }

      describe 'with default settings' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_foreman_proxy__plugin('openbolt') }
        it 'should configure openbolt.yml' do
          is_expected.to contain_file("#{etc_dir}/foreman-proxy/settings.d/openbolt.yml")
            .with_ensure('file')
            .with_owner('root')
            .with_group('foreman-proxy')

          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/openbolt.yml", [
                                  '---',
                                  ':enabled: https',
                                  ":environment_path: /etc/puppetlabs/code/environments/production",
                                  ":workers: 20",
                                  ":concurrency: 100",
                                  ":connect_timeout: 30",
                                  ":log_dir: /var/log/foreman-proxy/openbolt"
                                ])
        end
      end
    end
  end
end
