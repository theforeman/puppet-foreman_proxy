require 'spec_helper'

describe 'foreman_proxy::plugin::dynflow' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let :pre_condition do
        "include foreman_proxy"
      end

      let :etc_dir do
        case facts[:osfamily]
        when 'FreeBSD', 'DragonFly'
          '/usr/local/etc'
        else
          '/etc'
        end
      end

      has_core = facts[:osfamily] == 'Debian' || (facts[:osfamily] == 'RedHat' && facts[:operatingsystem] != 'Fedora')

      describe 'with default settings' do
        it { should compile.with_all_deps }
        it { should contain_foreman_proxy__plugin('dynflow') }

        it 'should generate correct dynflow.yml' do
          lines = [
            '---',
            ':enabled: https',
            ':database: ',
            ':core_url: https://foo.example.com:8008',
          ]
          lines << ':external_core: true' if has_core
          verify_exact_contents(catalogue,
                                "#{etc_dir}/foreman-proxy/settings.d/dynflow.yml",
                                lines)
        end

        if has_core
          it { should contain_foreman_proxy__plugin('dynflow_core') }
          it { should contain_service('smart_proxy_dynflow_core') }

          it 'should create settings.d symlink' do
            should contain_file("#{etc_dir}/smart_proxy_dynflow_core/settings.d").
              with_ensure('link').with_target("#{etc_dir}/foreman-proxy/settings.d")
          end

          it 'should create systemd service limits' do
            should contain_systemd__service_limits('smart_proxy_dynflow_core.service').
              with_limits({'LimitNOFILE' => 1000000}).that_notifies('Service[smart_proxy_dynflow_core]')
          end

          it 'should generate correct dynflow core settings.yml' do
            verify_exact_contents(catalogue, "#{etc_dir}/smart_proxy_dynflow_core/settings.yml", [
              "---",
              ":database: ",
              ":console_auth: true",
              ":foreman_url: https://foo.example.com",
              ":listen: 0.0.0.0",
              ":port: 8008",
              ":use_https: true",
              ":ssl_ca_file: /var/lib/puppet/ssl/certs/ca.pem",
              ":ssl_certificate: /var/lib/puppet/ssl/certs/foo.example.com.pem",
              ":ssl_private_key: /var/lib/puppet/ssl/private_keys/foo.example.com.pem",
            ])
          end
        else
          it { should_not contain_foreman_proxy__plugin('dynflow_core') }
          it { should_not contain_file("#{etc_dir}/smart_proxy_dynflow_core/settings.d") }
          it { should_not contain_file("#{etc_dir}/smart_proxy_dynflow_core/settings.yml") }
          it { should_not contain_service('smart_proxy_dynflow_core') }
          it { should_not contain_systemd__service_limits('smart_proxy_dynflow_core.service') }
        end
      end

      describe 'with custom settings' do
        let :params do {
          :database_path         => '/var/lib/foreman-proxy/dynflow/dynflow.sqlite',
          :ssl_disabled_ciphers  => ['NULL-MD5', 'NULL-SHA'],
          :tls_disabled_versions => ['1.1'],
          :open_file_limit       => 8000,
          :external_core         => false,
        } end

        it { should compile.with_all_deps }
        it { should contain_foreman_proxy__plugin('dynflow') }

        if has_core
          it 'should create settings.d symlink' do
            should contain_file("#{etc_dir}/smart_proxy_dynflow_core/settings.d").
              with_ensure('link').with_target("#{etc_dir}/foreman-proxy/settings.d")
          end

          it 'should create systemd service limits' do
            should contain_systemd__service_limits('smart_proxy_dynflow_core.service').
              with_limits({'LimitNOFILE' => 8000}).that_notifies('Service[smart_proxy_dynflow_core]')
          end

          it 'should generate correct dynflow core settings.yml' do
            verify_exact_contents(catalogue, "#{etc_dir}/smart_proxy_dynflow_core/settings.yml", [
              '---',
              ':database: /var/lib/foreman-proxy/dynflow/dynflow.sqlite',
              ':console_auth: true',
              ':foreman_url: https://foo.example.com',
              ':listen: 0.0.0.0',
              ':port: 8008',
              ':use_https: true',
              ':ssl_ca_file: /var/lib/puppet/ssl/certs/ca.pem',
              ':ssl_certificate: /var/lib/puppet/ssl/certs/foo.example.com.pem',
              ':ssl_private_key: /var/lib/puppet/ssl/private_keys/foo.example.com.pem',
              ':ssl_disabled_ciphers: ["NULL-MD5", "NULL-SHA"]',
              ':tls_disabled_versions: ["1.1"]',
            ])
          end

          it 'should generate correct dynflow.yml' do
            verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/dynflow.yml", [
              '---',
              ':enabled: https',
              ':database: /var/lib/foreman-proxy/dynflow/dynflow.sqlite',
              ':core_url: https://foo.example.com:8008',
              ':external_core: false',
            ])
          end
        else
          it { should_not contain_foreman_proxy__plugin('dynflow_core') }
          it { should_not contain_file("#{etc_dir}/smart_proxy_dynflow_core/settings.d") }
          it { should_not contain_file("#{etc_dir}/smart_proxy_dynflow_core/settings.yml") }
          it { should_not contain_service('smart_proxy_dynflow_core') }
          it { should_not contain_systemd__service_limits('smart_proxy_dynflow_core.service') }
        end
      end
    end
  end
end
