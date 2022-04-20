require 'spec_helper'

describe 'foreman_proxy' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:params) { {} }

      case facts[:osfamily]
      when 'FreeBSD', 'DragonFly'
        dns_group = 'bind'
        etc_dir = '/usr/local/etc'
        puppet_etc_dir = "#{etc_dir}/puppet"
        home_dir = '/usr/local/share/foreman-proxy'
        proxy_user_name = 'foreman_proxy'
        shell = '/usr/bin/false'
        puppet_path = '/usr/local/bin/puppet'
        ssl_dir = '/var/puppet/ssl'
      else
        dns_group = facts[:osfamily] == 'RedHat' ? 'named' : 'bind'
        etc_dir = '/etc'
        puppet_etc_dir = "#{etc_dir}/puppetlabs/puppet"
        home_dir = '/usr/share/foreman-proxy'
        proxy_user_name = 'foreman-proxy'
        shell = '/bin/false'
        puppet_path = '/opt/puppetlabs/bin/puppet'
        ssl_dir = '/etc/puppetlabs/puppet/ssl'
      end

      let(:tftp_root) do
        case facts[:osfamily]
        when 'Debian'
          '/srv/tftp'
        when 'FreeBSD', 'DragonFly'
          '/tftpboot'
        else
          '/var/lib/tftpboot'
        end
      end

      puppetca_command = "#{puppet_path} cert *"

      context 'without parameters' do
        it { should compile.with_all_deps }

        it 'should include classes' do
          should contain_class('foreman_proxy::install')
          should contain_class('foreman_proxy::config')
          should contain_class('foreman_proxy::service')
          should contain_class('foreman_proxy::register')
        end

        it { should_not contain_class('foreman::repo') }

        it 'should not include managed tftp' do
          should_not contain_class('foreman_proxy::tftp')
          should_not contain_class('tftp')
        end

        it 'should not include dns' do
          should_not contain_class('foreman_proxy::proxydns')
        end

        it 'should not include dhcp' do
          should_not contain_class('foreman_proxy::proxydhcp')
        end

        it 'should not install wget' do
          should_not contain_package('wget').with_ensure('installed')
        end

        it "should create the #{proxy_user_name} user" do
          should contain_user("#{proxy_user_name}")
            .with_ensure('present')
            .with_shell(shell)
            .with_comment('Foreman Proxy daemon user')
            .with_gid(proxy_user_name)
            .with_groups(['puppet'])
            .with_home(home_dir)
            .that_requires('Class[Foreman_proxy::Install]')
            .that_notifies('Class[Foreman_proxy::Service]')
        end

        it 'should create configuration files' do
          should contain_file("#{etc_dir}/foreman-proxy/settings.yml")
            .with_owner('root')
            .with_group(proxy_user_name)
            .with_mode('0640')
            .that_requires('Class[Foreman_proxy::Install]')
            .that_notifies('Class[Foreman_proxy::Service]')

          [
            'bmc',
            'dns', 'dns_libvirt', 'dns_nsupdate', 'dns_nsupdate_gss',
            'dhcp', 'dhcp_isc', 'dhcp_libvirt',
            'logs', 'httpboot', 'puppet', 'puppet_proxy_puppet_api',
            'puppetca', 'puppetca_http_api', 'puppetca_puppet_cert',
            'puppetca_hostname_whitelisting', 'puppetca_token_whitelisting',
            'realm', 'templates', 'tftp'
          ].each do |cfile|
            should contain_file("#{etc_dir}/foreman-proxy/settings.d/#{cfile}.yml")
              .with_owner('root')
              .with_group(proxy_user_name)
              .with_mode('0640')
              .that_requires('Class[Foreman_proxy::Install]')
              .that_notifies('Class[Foreman_proxy::Service]')
          end
        end

        it 'should remove old config files' do
          should contain_file("#{etc_dir}/foreman-proxy/settings.d/puppet_proxy_legacy.yml").with_ensure('absent')
          should contain_file("#{etc_dir}/foreman-proxy/settings.d/puppet_proxy_puppetrun.yml").with_ensure('absent')
        end

        context 'without IPv4' do
          let(:facts) { super().reject { |fact| fact == :ipaddress } }

          it { is_expected.to compile.with_all_deps }
        end

        context 'without IPv6' do
          let(:facts) { super().merge(ipaddress6: nil) }

          it 'should generate correct settings.yml' do
            bind_host = '*'

            verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.yml", [
              '---',
              ":settings_directory: #{etc_dir}/foreman-proxy/settings.d",
              ":ssl_ca_file: #{ssl_dir}/certs/ca.pem",
              ":ssl_certificate: #{ssl_dir}/certs/#{facts[:fqdn]}.pem",
              ":ssl_private_key: #{ssl_dir}/private_keys/#{facts[:fqdn]}.pem",
              ':trusted_hosts:',
              "  - #{facts[:fqdn]}",
              ":foreman_url: https://#{facts[:fqdn]}",
              ':daemon: true',
              ":bind_host: '#{bind_host}'",
              ':https_port: 8443',
              ':log_file: /var/log/foreman-proxy/proxy.log',
              ':log_level: INFO',
              ':log_buffer: 2000',
              ':log_buffer_errors: 1000',
            ])
          end
        end

        it 'should generate correct bmc.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/bmc.yml", [
            '---',
            ':enabled: false',
            ':bmc_default_provider: ipmitool',
          ])
        end

        it 'should generate correct dhcp.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/dhcp.yml", [
            '---',
            ':enabled: false',
            ':use_provider: dhcp_isc',
            ':server: 127.0.0.1',
            ':ping_free_ip: true',
          ])
        end

        it 'should generate correct dns.yml' do
          dns_key = case facts[:osfamily]
                    when 'Debian'
                      '/etc/bind/rndc.key'
                    when 'FreeBSD', 'DragonFly'
                      '/usr/local/etc/namedb/rndc.key'
                    else
                      '/etc/rndc.key'
                    end

          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/dns.yml", [
            '---',
            ':enabled: false',
            ':use_provider: dns_nsupdate',
            ':dns_ttl: 86400',
          ])

          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/dns_nsupdate.yml", [
            '---',
            ":dns_key: #{dns_key}",
            ':dns_server: 127.0.0.1',
          ])

          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/dhcp_libvirt.yml", [
            '---',
            ':network: default',
            ':url: qemu:///system',
          ])

          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/dns_libvirt.yml", [
            '---',
            ':network: default',
            ':url: qemu:///system',
          ])

          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/dns_nsupdate_gss.yml", [
            '---',
            ':dns_server: 127.0.0.1',
            ":dns_tsig_keytab: #{etc_dir}/foreman-proxy/dns.keytab",
            ":dns_tsig_principal: foremanproxy/#{facts[:fqdn]}@EXAMPLE.COM",
          ])
        end

        it 'should generate correct puppet.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/puppet.yml", [
            '---',
            ':enabled: https',
          ])
        end

        it 'should generate correct puppet_proxy_puppet_api.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/puppet_proxy_puppet_api.yml", [
            '---',
            ":puppet_url: https://#{facts[:fqdn]}:8140",
            ":puppet_ssl_ca: #{ssl_dir}/certs/ca.pem",
            ":puppet_ssl_cert: #{ssl_dir}/certs/#{facts[:fqdn]}.pem",
            ":puppet_ssl_key: #{ssl_dir}/private_keys/#{facts[:fqdn]}.pem",
            ":api_timeout: 30",
          ])
        end

        it 'should generate correct puppetca.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/puppetca.yml", [
            '---',
            ':enabled: https',
            ':use_provider: puppetca_hostname_whitelisting',
            ":puppet_version: #{Puppet.version}",
          ])
        end

        it 'should generate correct puppetca_http_api.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/puppetca_http_api.yml", [
            '---',
            ":puppet_url: https://#{facts[:fqdn]}:8140",
            ":puppet_ssl_ca: #{ssl_dir}/certs/ca.pem",
            ":puppet_ssl_cert: #{ssl_dir}/certs/#{facts[:fqdn]}.pem",
            ":puppet_ssl_key: #{ssl_dir}/private_keys/#{facts[:fqdn]}.pem",
          ])
        end

        it 'should generate correct puppetca_puppet_cert.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/puppetca_puppet_cert.yml", [
            '---',
            ":ssldir: #{ssl_dir}",
          ])
        end

        it 'should generate correct puppetca_hostname_whitelisting.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/puppetca_hostname_whitelisting.yml", [
            '---',
            ":autosignfile: #{puppet_etc_dir}/autosign.conf",
          ])
        end

        it 'should generate correct puppetca_token_whitelisting.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/puppetca_token_whitelisting.yml", [
            '---',
            ':tokens_file: /var/lib/foreman-proxy/tokens.yml',
            ':sign_all: false',
            ':token_ttl: 360',
          ])
        end

        it 'should generate correct httpboot.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/httpboot.yml", [
            '---',
            ':enabled: false',
            ":root_dir: #{tftp_root}",
          ])
        end

        it 'should generate correct tftp.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/tftp.yml", [
            '---',
            ':enabled: false',
            ":tftproot: #{tftp_root}",
          ])
        end

        it 'should generate correct realm.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/realm.yml", [
            '---',
            ':enabled: false',
            ':use_provider: realm_freeipa',
          ])
        end

        it 'should generate correct realm_freeipa.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/realm_freeipa.yml", [
            '---',
            ":keytab_path: #{etc_dir}/foreman-proxy/freeipa.keytab",
            ':principal: realm-proxy@EXAMPLE.COM',
            ':ipa_config: /etc/ipa/default.conf',
            ':remove_dns: true',
          ])
        end

        it 'should generate correct templates.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/templates.yml", [
            '---',
            ':enabled: false',
            ":template_url: http://#{facts[:fqdn]}:8000",
          ])
        end

        it 'should generate correct registration.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/registration.yml", [
            '---',
            ':enabled: false',
          ])
        end

        it 'should generate correct logs.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/logs.yml", [
            '---',
            ':enabled: https'
          ])
        end

        it 'should set up sudo rules', if: Puppet.version < '6.0' do
          should contain_file("#{etc_dir}/sudoers.d").with_ensure('directory')

          should contain_file("#{etc_dir}/sudoers.d/foreman-proxy").with({
            :ensure  => 'file',
            :owner   => 'root',
            :group   => 0,
            :mode    => '0440',
          })

          verify_exact_contents(catalogue, "#{etc_dir}/sudoers.d/foreman-proxy", [
            "#{proxy_user_name} ALL = (root) NOPASSWD : #{puppetca_command}",
            "Defaults:#{proxy_user_name} !requiretty",
          ])
        end

        it 'should not set up sudo rules', if: Puppet.version >= '6.0' do
          should_not contain_file("#{etc_dir}/sudoers.d")
          should contain_file("#{etc_dir}/sudoers.d/foreman-proxy").with_ensure('absent')
        end

        it "should not manage puppet group" do
          should_not contain_group('puppet')
        end
      end

      context 'without a domain' do
        let(:facts) { override_facts(super(), networking: {domain: nil}, domain: nil) }

        it { is_expected.to compile.with_all_deps }
      end

      context 'with custom foreman_ssl params' do
        let :params do
          super().merge(
            foreman_ssl_ca: "/etc/pki/ca.pem",
            foreman_ssl_cert: "/etc/pki/cert.pem",
            foreman_ssl_key: "/etc/pki/key.pem",
          )
        end

        it 'should generate correct settings.yml' do
          verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.yml", [
            ":foreman_ssl_ca: /etc/pki/ca.pem",
            ":foreman_ssl_cert: /etc/pki/cert.pem",
            ":foreman_ssl_key: /etc/pki/key.pem"
          ])
        end
      end

      describe 'group management' do
        let(:params) { super().merge(manage_puppet_group: false) }

        context 'with puppet => false' do
          let(:params) { super().merge(puppet: false) }

          context 'with puppetca => false' do
            let(:params) { super().merge(puppetca: false) }

            context 'with dns => false' do
              let(:params) { super().merge(dns: false) }
              it { should compile.with_all_deps }
              it { should contain_user(proxy_user_name).with_groups([]) }
            end

            context 'with dns => true' do
              let(:facts) { super().merge(ipaddress_eth0: '192.168.0.2', netmask_eth0: '255.255.255.0') }
              let(:params) { super().merge(dns: true) }
              it { should compile.with_all_deps }
              it { should contain_user(proxy_user_name).with_groups([dns_group]) }
            end
          end

          context 'with puppetca => true' do
            let(:params) { super().merge(puppetca: true) }
            it { should compile.with_all_deps }
            it { should contain_user(proxy_user_name).with_groups(['puppet']) }
          end
        end

        context 'with puppet => true' do
          let(:params) { super().merge(puppet: true) }

          context 'with puppetca => false' do
            let(:params) { super().merge(puppetca: false) }
            it { should compile.with_all_deps }
            it { should contain_user(proxy_user_name).with_groups(['puppet']) }
          end

          context 'with puppetca => true' do
            let(:params) { super().merge(puppetca: true) }
            it { should compile.with_all_deps }
            it { should contain_user(proxy_user_name).with_groups(['puppet']) }
          end

          context 'with dns => true' do
            let(:facts) { super().merge(ipaddress_eth0: '192.168.0.2', netmask_eth0: '255.255.255.0') }
            let(:params) { super().merge(dns: true) }
            it { should compile.with_all_deps }
            it { should contain_user(proxy_user_name).with_groups([dns_group, 'puppet']) }
          end
        end

        context 'with custom groups defined' do
          let(:params) { super().merge(groups: ['test_group1', 'test_group2']) }

          context 'with dns => false' do
            let(:params) { super().merge(dns: false) }
            it { should compile.with_all_deps }
            it { should contain_user(proxy_user_name).with_groups(['test_group1', 'test_group2', 'puppet']) }
          end

          context 'with dns => true' do
            let(:facts) { super().merge(ipaddress_eth0: '192.168.0.2', netmask_eth0: '255.255.255.0') }
            let(:params) { super().merge(dns: true) }
            it { should compile.with_all_deps }
            it { should contain_user(proxy_user_name).with_groups(['test_group1', 'test_group2', dns_group, 'puppet']) }
          end
        end
      end

      context 'with tftp' do
        let(:params) { super().merge(tftp: true) }

        it 'should generate correct httpboot.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/httpboot.yml", [
            '---',
            ':enabled: false',
            ":root_dir: #{tftp_root}",
          ])
        end

        it 'should generate correct tftp.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/tftp.yml", [
            '---',
            ':enabled: https',
            ":tftproot: #{tftp_root}",
          ])
        end

        it do
          should contain_class('foreman_proxy::tftp')
            .with_user(proxy_user_name)
            .with_root(tftp_root)
            .with_manage_wget(true)
            .with_wget_version('installed')
        end

        it 'should install wget' do
          should contain_package('wget').with_ensure('installed')
        end

        context 'with custom tftp parameters' do
          let :params do
            super().merge(
              tftp_root: '/tftproot',
              tftp_servername: '127.0.1.1',
            )
          end

          it 'should generate correct tftp.yml' do
            verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/tftp.yml", [
              '---',
              ':enabled: https',
              ':tftproot: /tftproot',
              ':tftp_servername: 127.0.1.1'
            ])
          end
        end

        context 'with tftp_managed => false' do
          let(:params) { super().merge(tftp_managed: false) }

          it 'should not include the foreman-proxy tftp class' do
            should_not contain_class('foreman_proxy::tftp')
          end

          it 'should not include the ::tftp class' do
            should_not contain_class('tftp')
          end
        end

        context 'with tftp_managed => true' do
          let(:params) { super().merge(tftp_managed: true) }

          context 'with tftp_manage_wget disabled' do
            let(:params) { super().merge(tftp_manage_wget: false) }
            it { should_not contain_package('wget') }
          end
        end
      end

      context 'with bmc' do
        let(:params) { super().merge(bmc: true) }

        context 'shell provider' do
          let(:params) { super().merge(bmc_default_provider: 'shell') }

          it 'should enable bmc with shell' do
            verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/bmc.yml", [
              '---',
              ':enabled: https',
              ':bmc_default_provider: shell',
            ])
          end
        end

        context 'ssh provider' do
          let(:params) { super().merge(bmc_default_provider: 'ssh') }

          it 'should enable bmc with ssh' do
            verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/bmc.yml", [
              '---',
              ':enabled: https',
              ':bmc_default_provider: ssh',
              ':bmc_ssh_user: root',
              ':bmc_ssh_key: /usr/share/foreman/.ssh/id_rsa',
              ':bmc_ssh_powerstatus: "true"',
              ':bmc_ssh_powercycle: "shutdown -r +1"',
              ':bmc_ssh_poweroff: "shutdown +1"',
              ':bmc_ssh_poweron: "false"',
            ])
          end
        end

        context 'redfish provider' do
          let(:params) { super().merge(bmc_default_provider: 'redfish') }

          it 'should enable bmc with ssh' do
            verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/bmc.yml", [
              '---',
              ':enabled: https',
              ':bmc_default_provider: redfish',
              ':redfish_verify_ssl: true',
            ])
          end
        end
      end

      context 'only http enabled' do
        let(:params) { super().merge(ssl: false, http: true) }

        it 'should comment out ssl configuration items' do
          verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.yml", [
            '#:ssl_ca_file: ssl/certs/ca.pem',
            '#:ssl_certificate: ssl/certs/fqdn.pem',
            '#:ssl_private_key: ssl/private_keys/fqdn.key',
            '#:https_port: 8443',
            ':http_port: 8000',
          ])
        end
      end

      context 'both http and ssl enabled' do
        let(:params) do
          super().merge(
            ssl: true,
            ssl_port: 867,
            http: true,
            http_port: 5309,
          )
        end

        it 'should configure both http and ssl on their respective ports' do
          verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.yml", [
            ':https_port: 867',
            ':http_port: 5309',
          ])
        end
      end

      context 'bind_host set to string' do
        let(:params) { super().merge(bind_host: '*') }

        it 'should set bind_host to a string' do
          verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.yml", [
            ':bind_host: \'*\'',
          ])
        end
      end

      context 'bind_host set to array' do
        let(:params) { super().merge(bind_host: ["eth0", "192.168.0.1"]) }

        it 'should set bind_host to an array' do
          verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.yml", [
            ':bind_host:',
            '  - "eth0"',
            '  - "192.168.0.1"',
          ])
        end
      end

      context 'with dns => true' do
        let(:params) { super().merge(dns: true) }
        let(:facts) { super().merge(ipaddress_eth0: '192.168.0.2', netmask_eth0: '255.255.255.0') }

        let(:nsupdate_pkg) do
          case facts[:osfamily]
          when 'RedHat'
            'bind-utils'
          when 'FreeBSD', 'DragonFly'
            'bind-tools'
          else
            'dnsutils'
          end
        end

        it { is_expected.to contain_class('foreman_proxy').with_dns_provider('nsupdate').with_dns_managed(true) }

        context 'dns_provider => nsupdate' do
          let(:params) { super().merge(dns_provider: 'nsupdate') }

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_package(nsupdate_pkg).with_ensure('installed') }
          it { is_expected.to contain_class('foreman_proxy::proxydns') }

          context 'dns_managed => false' do
            let(:params) { super().merge(dns_managed: false) }

            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_package(nsupdate_pkg).with_ensure('installed') }
            it { is_expected.not_to contain_class('foreman_proxy::proxydns') }
          end
        end

        context 'when dns_provider => nsupdate_gss' do
          let(:params) { super().merge(dns_provider: 'nsupdate_gss') }

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_package(nsupdate_pkg).with_ensure('installed') }
          it { is_expected.to contain_class('foreman_proxy::proxydns') }

          it 'should contain dns_tsig_* settings' do
            verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/dns.yml", [
              '---',
              ':enabled: https',
              ':use_provider: dns_nsupdate_gss',
              ':dns_ttl: 86400',
            ])

            verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/dns_nsupdate_gss.yml", [
              '---',
              ':dns_server: 127.0.0.1',
              ":dns_tsig_keytab: #{etc_dir}/foreman-proxy/dns.keytab",
              ":dns_tsig_principal: foremanproxy/#{facts[:fqdn]}@EXAMPLE.COM",
            ])
          end
        end

        context 'when dns_provider => libvirt' do
          let(:params) do
            super().merge(
              dns_provider: 'libvirt',
              libvirt_network: 'mynet',
              libvirt_connection: 'http://myvirt',
            )
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.not_to contain_package(nsupdate_pkg) }
          it { is_expected.not_to contain_class('foreman_proxy::proxydns') }

          it 'should generate the correct configs' do
            verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/dns.yml", [
              '---',
              ':enabled: https',
              ':use_provider: dns_libvirt',
              ':dns_ttl: 86400',
            ])

            verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/dns_libvirt.yml", [
              '---',
              ':network: mynet',
              ':url: http://myvirt',
            ])
          end
        end
      end

      context 'empty keyfile' do
        let(:params) { super().merge(keyfile: '') }

        it 'should not output dns_key' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/dns_nsupdate.yml", [
            '---',
            ':dns_server: 127.0.0.1',
          ])
        end
      end

      context 'when puppet_api_timeout set' do
        let(:params) { super().merge(puppet_api_timeout: 600) }

        it 'should set puppet_api_timeout' do
          should contain_file("#{etc_dir}/foreman-proxy/settings.d/puppet_proxy_puppet_api.yml").with_content(/^:api_timeout: 600$/)
        end
      end

      context 'when trusted_hosts is empty' do
        let(:params) { super().merge(trusted_hosts: []) }

        it 'should not set trusted_hosts' do
          should contain_file("#{etc_dir}/foreman-proxy/settings.yml").without_content(/[^#]:trusted_hosts/)
        end
      end

      context 'with custom foreman_base_url' do
        let(:params) { super().merge(foreman_base_url: "http://dummy") }

        it 'should generate foreman_url setting' do
          should contain_file("#{etc_dir}/foreman-proxy/settings.yml").with_content(%r{^:foreman_url: http://dummy$})
        end
      end

      context 'when puppetca_cmd set', if: Puppet.version < '6.0' do
        let(:params) { super().merge(puppetca_cmd: 'pup cert') }

        it "should set puppetca_cmd" do
          verify_exact_contents(catalogue, "#{etc_dir}/sudoers.d/foreman-proxy", [
            "#{proxy_user_name} ALL = (root) NOPASSWD : pup cert *",
            "Defaults:#{proxy_user_name} !requiretty",
          ])
        end
      end

      context 'with custom puppetca params' do
        let(:params) do
          super().merge(
            puppetca_provider: 'puppetca_token_whitelisting',
            puppetca_sign_all: true,
            puppetca_tokens_file: '/foo/bar.yml',
            autosignfile: '/bar/baz.conf',
            puppetca_token_ttl: 42,
            puppetca_certificate: '/bar/baz.pem',
          )
        end

        it 'should generate correct puppetca.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/puppetca.yml", [
            '---',
            ':enabled: https',
            ':use_provider: puppetca_token_whitelisting',
            ":puppet_version: #{Puppet.version}",
          ])
        end

        it 'should generate correct puppetca_hostname_whitelisting.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/puppetca_hostname_whitelisting.yml", [
            '---',
            ":autosignfile: /bar/baz.conf",
          ])
        end

        it 'should generate correct puppetca_token_whitelisting.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/puppetca_token_whitelisting.yml", [
            '---',
            ':tokens_file: /foo/bar.yml',
            ':sign_all: true',
            ':token_ttl: 42',
            ':certificate: /bar/baz.pem',
          ])
        end
      end

      context 'with templates => true' do
        let(:params) { super().merge(templates: true) }

        context 'with feature on http' do
          let(:params) { super().merge(templates_listen_on: 'http') }

          it 'should set enabled to http' do
            verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/templates.yml", [
              ':enabled: http',
            ])
          end
        end

        context 'with feature on https' do
          let(:params) { super().merge(templates_listen_on: 'https') }

          it 'should set enabled to https' do
            verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/templates.yml", [
              ':enabled: https',
            ])
          end
        end

        context 'with feature on both' do
          let(:params) { super().merge(templates_listen_on: 'both') }

          it 'should set enabled to true' do
            verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/templates.yml", [
              ':enabled: true',
            ])
          end
        end
      end

      context 'with registration => true' do
        let(:params) { super().merge(registration: true) }

        context 'with feature on http' do
          let(:params) { super().merge(registration_listen_on: 'http') }

          it 'should set enabled to http' do
            verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/registration.yml", [
              ':enabled: http',
            ])
          end
        end

        context 'with feature on https' do
          let(:params) { super().merge(registration_listen_on: 'https') }

          it 'should set enabled to https' do
            verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/registration.yml", [
              ':enabled: https',
            ])
          end
        end

        context 'with feature on both' do
          let(:params) { super().merge(registration_listen_on: 'both') }

          it 'should set enabled to true' do
            verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/registration.yml", [
              ':enabled: true',
            ])
          end
        end
      end

      context 'when log_level => DEBUG' do
        let(:params) { super().merge(log_level: 'DEBUG') }

        it 'should set log_level to DEBUG in setting.yml' do
          verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.yml", [
            ':log_level: DEBUG',
          ])
        end
      end

      context 'with journald' do
        let(:params) { super().merge(log: 'JOURNAL') }
        it { is_expected.to contain_package('foreman-proxy-journald') }
        it { is_expected.to contain_file("#{etc_dir}/foreman-proxy/settings.yml").with_content(%r{^:log_file: JOURNAL$}) }
      end

      context 'with dhcp enabled' do
        let(:params) { super().merge(dhcp: true) }

        context 'dhcp_provider => isc' do
          let(:params) { super().merge(dhcp_interface: 'dhcpif') }
          let(:facts) { super().merge(ipaddress_dhcpif: '192.0.2.1', network_dhcpif: '192.0.2.0', netmask_dhcpif: '255.255.255.0') }

          case facts[:osfamily]
          when 'FreeBSD', 'DragonFly'
            dhcp_leases    = '/var/db/dhcpd/dhcpd.leases'
            dhcp_config    = "#{etc_dir}/dhcpd.conf"
          when 'Debian'
            dhcp_leases    = '/var/lib/dhcp/dhcpd.leases'
            dhcp_config    = "#{etc_dir}/dhcp/dhcpd.conf"
          else
            dhcp_leases    = '/var/lib/dhcpd/dhcpd.leases'
            dhcp_config    = "#{etc_dir}/dhcp/dhcpd.conf"
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('foreman_proxy::proxydhcp') }

          it 'should generate correct dhcp.yml' do
            verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/dhcp.yml", [
              '---',
              ':enabled: https',
              ':use_provider: dhcp_isc',
              ':server: 127.0.0.1',
              ':ping_free_ip: true',
            ])
          end

          it 'should generate correct dhcp_isc.yml' do
            verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/dhcp_isc.yml", [
              '---',
              ":config: #{dhcp_config}",
              ":leases: #{dhcp_leases}",
              ':omapi_port: 7911',
            ])
          end

          context 'dhcp_managed => false' do
            let(:params) { super().merge(dhcp_managed: false) }

            it { is_expected.to compile.with_all_deps }
            it { is_expected.not_to contain_class('foreman_proxy::proxydhcp') }

            it 'should generate correct dhcp_isc.yml' do
              verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/dhcp_isc.yml", [
                '---',
                ":config: #{dhcp_config}",
                ":leases: #{dhcp_leases}",
                ':omapi_port: 7911',
              ])
            end
          end
        end

        context 'when dhcp_provider => libvirt' do
          let(:params) do
            super().merge(
              dhcp_provider: 'libvirt',
              libvirt_network: 'mynet',
              libvirt_connection: 'http://myvirt',
            )
          end

          it { is_expected.to compile.with_all_deps }
          it { is_expected.not_to contain_class('foreman_proxy::proxydhcp') }

          it 'should set the provider correctly' do
            verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/dhcp.yml", [
              '---',
              ':enabled: https',
              ':use_provider: dhcp_libvirt',
              ':server: 127.0.0.1',
              ':ping_free_ip: true',
            ])

            verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/dhcp_libvirt.yml", [
              '---',
              ':network: mynet',
              ':url: http://myvirt',
            ])
          end
        end
      end

      context 'with ssl_disabled_ciphers' do
        let(:params) { super().merge(ssl_disabled_ciphers: ['CIPHER-SUITE-1', 'CIPHER-SUITE-2']) }

        it 'should set ssl_disabled_ciphers to YAML array in settings.yml' do
          verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.yml", [
            ':ssl_disabled_ciphers:',
            '  - CIPHER-SUITE-1',
            '  - CIPHER-SUITE-2',
          ])
        end
      end

      context 'with tls_disabled_versions' do
        let(:params) { super().merge(tls_disabled_versions: ['1.1']) }

        it 'should set tls_disabled_versions to YAML array in settings.yml' do
          verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.yml", [
            ':tls_disabled_versions:',
            '  - 1.1'
          ])
        end
      end

      describe 'manage_puppet_group' do
        context 'when puppet and puppetca are false and manage_puppet_group = true' do
          let(:params) do
            super().merge(
              puppet: false,
              puppetca: false,
              manage_puppet_group: true,
            )
          end

          context 'when ssl = true' do
            let(:params) { super().merge(ssl: true) }

            it { should compile.with_all_deps }
            it { should contain_user(proxy_user_name).with_groups(['puppet']) }

            it 'manages puppet group' do
              should contain_group('puppet').with_ensure('present').that_comes_before("User[#{proxy_user_name}]")
            end

            it 'sets group ownership to puppet on ssl files' do
              should contain_file("#{ssl_dir}").with_group('puppet')
              should contain_file("#{ssl_dir}/private_keys").with_group('puppet')
              should contain_file("#{ssl_dir}/certs/ca.pem").with_group('puppet')
              should contain_file("#{ssl_dir}/certs/#{facts[:fqdn]}.pem").with_group('puppet')
              should contain_file("#{ssl_dir}/private_keys/#{facts[:fqdn]}.pem").with_group('puppet')
            end

            context 'when puppet group is already being managed' do
              let(:pre_condition) { 'group {"puppet": ensure => present}' }
              it { should compile.with_all_deps }
              it { should contain_user(proxy_user_name).with_groups(['puppet']) }
              it 'does not manage puppet group' do
                should_not contain_group('puppet').with_before("User[#{proxy_user_name}]")
              end
            end
          end

          context 'when ssl = false' do
            let(:params) { super().merge(ssl: false) }
            it { should compile.with_all_deps }
            it { should contain_user(proxy_user_name).with_groups([]) }
            it 'does not manage puppet group' do
              should_not contain_group('puppet')
            end
          end
        end
      end

      context 'with foreman::repo included', unless: ['FreeBSD', 'DragonFly'].include?(facts[:operatingsystem]) do
        let(:pre_condition) do
          <<-PUPPET
          class { 'foreman::repo':
            repo => 'nightly',
          }
          PUPPET
        end

        it { should compile.with_all_deps }
        it { should contain_package('foreman-proxy').that_requires('Anchor[foreman::repo]') }
      end

      context 'with shell' do
        let(:pre_condition) do
          <<~PP
          class { 'foreman_proxy::globals':
            shell => "/dne/foo",
          }
          PP
        end

        it { should contain_user("#{proxy_user_name}").with_shell('/dne/foo') }
      end
    end
  end
end
