require 'spec_helper'

describe 'foreman_proxy::plugin::dynflow' do
  on_plugin_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:pre_condition) { 'include foreman_proxy' }
      let(:etc_dir) { ['FreeBSD', 'DragonFly'].include?(facts[:os]['family']) ? '/usr/local/etc' : '/etc' }

      describe 'with default settings' do
        it { should compile.with_all_deps }
        it { should contain_foreman_proxy__plugin__module('dynflow') }

        it 'should generate correct dynflow.yml' do
          lines = [
            '---',
            ':enabled: https',
            ':database: ',
            ':console_auth: true',
          ]
          verify_exact_contents(catalogue,
                                "#{etc_dir}/foreman-proxy/settings.d/dynflow.yml",
                                lines)
        end

        it do
          should contain_systemd__manage_dropin('foreman-proxy.service-90-limits.conf')
            .with_unit('foreman-proxy.service')
            .with_filename('90-limits.conf')
            .with_service_entry({'LimitNOFILE' => 1000000})
        end
      end

      describe 'with custom settings' do
        let :params do {
          :database_path         => '/var/lib/foreman-proxy/dynflow/dynflow.sqlite',
          :ssl_disabled_ciphers  => ['NULL-MD5', 'NULL-SHA'],
          :tls_disabled_versions => ['1.1'],
          :open_file_limit       => 8000,
        } end

        it { should compile.with_all_deps }
        it { should contain_foreman_proxy__plugin__module('dynflow') }

        it 'should generate correct dynflow.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/dynflow.yml", [
            '---',
            ':enabled: https',
            ':database: /var/lib/foreman-proxy/dynflow/dynflow.sqlite',
            ':console_auth: true',
          ])
        end
      end
    end
  end
end
