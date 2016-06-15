require 'spec_helper'

describe 'foreman_proxy::config' do
  on_supported_os.each do |os, facts|
    next if only_test_os() and not only_test_os.include?(os)
    next if exclude_test_os() and exclude_test_os.include?(os)
    context "on #{os}" do
      let(:facts) { facts }

      case facts[:osfamily]
      when 'FreeBSD', 'DragonFly'
        etc_dir = '/usr/local/etc'
        home_dir = '/usr/local/share/foreman-proxy'
        proxy_user_name = 'foreman_proxy'
        shell = '/usr/bin/false'
        usr_dir = '/usr/local'
        var_dir = '/var/puppet'
      else
        etc_dir = '/etc'
        home_dir = '/usr/share/foreman-proxy'
        proxy_user_name = 'foreman-proxy'
        shell = '/bin/false'
        usr_dir = '/usr'
        var_dir = '/var/lib/puppet'
      end

      if (facts[:puppetversion].to_i >2)
        puppetca_command = "#{usr_dir}/bin/puppet cert *"
        puppetrun_command = "#{usr_dir}/bin/puppet kick *"
      else
        puppetca_command = '/usr/sbin/puppetca *'
        puppetrun_command = '/usr/sbin/puppetrun *'
      end

      context 'without parameters' do
        let :pre_condition do
          'class {"foreman_proxy":}'
        end

        it { should compile.with_all_deps }

        it 'should include tftp' do
          should contain_class('foreman_proxy::tftp')
          should contain_class('tftp')
        end

        it 'should not include dns' do
          should_not contain_class('foreman_proxy::proxydns')
        end

        it 'should not include dhcp' do
          should_not contain_class('foreman_proxy::proxydhcp')
        end

        it 'should install wget' do
          should contain_package('wget').with_ensure('present')
        end

        it "should create the #{proxy_user_name} user" do
          should contain_user("#{proxy_user_name}").with({
            :ensure  => 'present',
            :shell   => "#{shell}",
            :comment => 'Foreman Proxy account',
            :groups  => ['puppet'],
            :home    => "#{home_dir}",
            :require => 'Class[Foreman_proxy::Install]',
            :notify  => 'Class[Foreman_proxy::Service]',
          })
        end

        it 'should create configuration files' do
          [ 'settings.yml', 'settings.d/bmc.yml', 'settings.d/dns.yml',
            'settings.d/dns_nsupdate.yml', 'settings.d/dns_nsupdate_gss.yml',
            'settings.d/dns_libvirt.yml', 'settings.d/dhcp.yml', 'settings.d/dhcp_isc.yml',
            'settings.d/dhcp_libvirt.yml', 'settings.d/logs.yml', 'settings.d/puppet.yml',
            'settings.d/puppetca.yml', 'settings.d/puppet_proxy_customrun.yml',
            'settings.d/puppet_proxy_legacy.yml', 'settings.d/puppet_proxy_mcollective.yml',
            'settings.d/puppet_proxy_puppet_api.yml', 'settings.d/puppet_proxy_puppetrun.yml',
            'settings.d/puppet_proxy_salt.yml', 'settings.d/puppet_proxy_ssh.yml',
            'settings.d/realm.yml', 'settings.d/templates.yml', 'settings.d/tftp.yml' ].each do |cfile|
            should contain_file("#{etc_dir}/foreman-proxy/#{cfile}").
              with({
                :owner   => 'root',
                :group   => "#{proxy_user_name}",
                :mode    => '0640',
                :require => 'Class[Foreman_proxy::Install]',
                :notify  => 'Class[Foreman_proxy::Service]',
              })
          end
        end

        it 'should generate correct settings.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.yml", [
            '---',
            ":settings_directory: #{etc_dir}/foreman-proxy/settings.d",
            ":ssl_ca_file: #{var_dir}/ssl/certs/ca.pem",
            ":ssl_certificate: #{var_dir}/ssl/certs/#{facts[:fqdn]}.pem",
            ":ssl_private_key: #{var_dir}/ssl/private_keys/#{facts[:fqdn]}.pem",
            ':trusted_hosts:',
            "  - #{facts[:fqdn]}",
            ":foreman_url: https://#{facts[:fqdn]}",
            ':daemon: true',
            ':bind_host: \'*\'',
            ':https_port: 8443',
            ':log_file: /var/log/foreman-proxy/proxy.log',
            ':log_level: INFO',
            ':log_buffer: 2000',
            ':log_buffer_errors: 1000',
          ])
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
            ":puppet_version: #{Puppet.version}",
          ])
        end

        it 'should generate correct puppet_proxy_customrun.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/puppet_proxy_customrun.yml", [
            '---',
            ":command: #{shell}",
            ':command_arguments: -ay -f -s',
          ])
        end

        it 'should generate correct puppet_proxy_legacy.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/puppet_proxy_legacy.yml", [
            '---',
            ":puppet_conf: #{etc_dir}/puppet/puppet.conf",
            ":puppet_url: https://#{facts[:fqdn]}:8140",
            ":puppet_ssl_ca: #{var_dir}/ssl/certs/ca.pem",
            ":puppet_ssl_cert: #{var_dir}/ssl/certs/#{facts[:fqdn]}.pem",
            ":puppet_ssl_key: #{var_dir}/ssl/private_keys/#{facts[:fqdn]}.pem",
          ])
        end

        it 'should generate correct puppet_proxy_mcollective.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/puppet_proxy_mcollective.yml", [
            '---',
            ':user: root',
          ])
        end

        it 'should generate correct puppet_proxy_puppet_api.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/puppet_proxy_puppet_api.yml", [
            '---',
            ":puppet_url: https://#{facts[:fqdn]}:8140",
            ":puppet_ssl_ca: #{var_dir}/ssl/certs/ca.pem",
            ":puppet_ssl_cert: #{var_dir}/ssl/certs/#{facts[:fqdn]}.pem",
            ":puppet_ssl_key: #{var_dir}/ssl/private_keys/#{facts[:fqdn]}.pem",
          ])
        end

        it 'should generate correct puppet_proxy_puppetrun.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/puppet_proxy_puppetrun.yml", [
            '---',
            ':user: root',
          ])
        end

        it 'should generate correct puppet_proxy_salt.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/puppet_proxy_salt.yml", [
            '---',
            ':command: puppet.run',
          ])
        end

        it 'should generate correct puppet_proxy_ssh.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/puppet_proxy_ssh.yml", [
            '---',
            ":command: #{usr_dir}/bin/puppet agent --onetime --no-usecacheonfailure",
            ':use_sudo: false',
            ':wait: false',
            ':user: root',
            ":keyfile: #{etc_dir}/foreman-proxy/id_rsa",
          ])
        end

        it 'should generate correct puppetca.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/puppetca.yml", [
            '---',
            ':enabled: https',
            ":ssldir: #{var_dir}/ssl",
            ":puppetdir: #{etc_dir}/puppet",
          ])
        end

        it 'should generate correct tftp.yml' do
          tftp_root = case facts[:osfamily]
                      when 'Debian'
                        case facts[:operatingsystem]
                        when 'Ubuntu'
                          '/var/lib/tftpboot'
                        else
                          '/srv/tftp'
                        end
                      when 'FreeBSD', 'DragonFly'
                        '/tftpboot'
                      else
                        '/var/lib/tftpboot'
                      end

          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/tftp.yml", [
            '---',
            ':enabled: https',
            ":tftproot: #{tftp_root}",
          ])
        end

        if facts[:osfamily] == 'Debian'
          if facts[:operatingsystem] == 'Ubuntu' && facts[:operatingsystemrelease] == '14.04'
            it 'should copy the correct default files for Ubuntu 14.04' do
              should contain_foreman_proxy__tftp__copy_file('/usr/lib/syslinux/chain.c32')
              should contain_foreman_proxy__tftp__copy_file('/usr/lib/syslinux/mboot.c32')
              should contain_foreman_proxy__tftp__copy_file('/usr/lib/syslinux/menu.c32')
              should contain_foreman_proxy__tftp__copy_file('/usr/lib/syslinux/memdisk')
              should contain_foreman_proxy__tftp__copy_file('/usr/lib/syslinux/pxelinux.0')
            end
          else
            it 'should copy the correct default files for newer Debian/Ubuntu versions' do
              should contain_foreman_proxy__tftp__copy_file('/usr/lib/PXELINUX/pxelinux.0')
              should contain_foreman_proxy__tftp__copy_file('/usr/lib/syslinux/memdisk')
              should contain_foreman_proxy__tftp__copy_file('/usr/lib/syslinux/modules/bios/chain.c32')
              should contain_foreman_proxy__tftp__copy_file('/usr/lib/syslinux/modules/bios/ldlinux.c32')
              should contain_foreman_proxy__tftp__copy_file('/usr/lib/syslinux/modules/bios/libcom32.c32')
              should contain_foreman_proxy__tftp__copy_file('/usr/lib/syslinux/modules/bios/libutil.c32')
              should contain_foreman_proxy__tftp__copy_file('/usr/lib/syslinux/modules/bios/mboot.c32')
              should contain_foreman_proxy__tftp__copy_file('/usr/lib/syslinux/modules/bios/menu.c32')
            end
          end
        end

        it 'should generate correct realm.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/realm.yml", [
            '---',
            ':enabled: false',
            ':realm_provider: freeipa',
            ":realm_keytab: #{etc_dir}/foreman-proxy/freeipa.keytab",
            ':realm_principal: realm-proxy@EXAMPLE.COM',
            ':freeipa_remove_dns: true',
          ])
        end

        it 'should generate correct templates.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/templates.yml", [
            '---',
            ':enabled: false',
            ":template_url: http://#{facts[:fqdn]}:8000",
          ])
        end

        it 'should generate correct logs.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/logs.yml", [
            '---',
            ':enabled: false'
          ])
        end

        it 'should set up sudo rules' do
          should contain_file("#{etc_dir}/sudoers.d").with_ensure('directory')

          should contain_file("#{etc_dir}/sudoers.d/foreman-proxy").with({
            :ensure  => 'file',
            :owner   => 'root',
            :group   => 0,
            :mode    => '0440',
          })

          verify_exact_contents(catalogue, "#{etc_dir}/sudoers.d/foreman-proxy", [
            "#{proxy_user_name} ALL = (root) NOPASSWD : #{puppetca_command}",
            "#{proxy_user_name} ALL = (root) NOPASSWD : #{puppetrun_command}",
            "Defaults:#{proxy_user_name} !requiretty",
          ])
        end

        it "should not manage #{etc_dir}/sudoers.d" do
          should contain_file("#{etc_dir}/sudoers.d").with_ensure('directory')
        end

        it "should not manage puppet group" do
          should_not contain_group('puppet')
        end
      end

      context 'with custom foreman_ssl params' do
        let(:facts) { facts }

        let :pre_condition do
          'class {"foreman_proxy":
             foreman_ssl_ca   => "/etc/pki/ca.pem",
             foreman_ssl_cert => "/etc/pki/cert.pem",
             foreman_ssl_key => "/etc/pki/key.pem",
           }'
        end

        it 'should generate correct settings.yml' do
          verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.yml", [
            ":foreman_ssl_ca: /etc/pki/ca.pem",
            ":foreman_ssl_cert: /etc/pki/cert.pem",
            ":foreman_ssl_key: /etc/pki/key.pem"
          ])
        end
      end

      context 'with custom tftp parameters' do
        let :pre_condition do
          'class {"foreman_proxy":
            tftp_root       => "/tftproot",
            tftp_servername => "127.0.1.1",
          }'
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
        let :pre_condition do
          'class {"foreman_proxy":
            tftp_managed => false,
          }'
        end

        it 'should include the foreman-proxy tftp class' do
          should contain_class('foreman_proxy::tftp')
        end

        it 'should not include the ::tftp class' do
          should_not contain_class('tftp')
        end
      end

      context 'with bmc' do
        let :pre_condition do
          'class {"foreman_proxy":
            bmc                  => true,
            bmc_default_provider => "shell",
          }'
        end

        it 'should enable bmc with shell' do
          verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/bmc.yml", [
            ':enabled: https',
            ':bmc_default_provider: shell',
          ])
        end
      end

      context 'with TFTP enabled and tftp_syslinux_filenames set' do
        let :pre_condition do
          'class {"foreman_proxy":
            tftp => true,
            tftp_syslinux_filenames => [ "/my/file", "/my/anotherfile" ],
          }'
        end

        it 'should copy the given files' do
          should contain_foreman_proxy__tftp__copy_file('/my/file')
          should contain_foreman_proxy__tftp__copy_file('/my/anotherfile')
        end
      end

      context 'with tftp_manage_wget disabled' do
        let :pre_condition do
          'class {"foreman_proxy":
            tftp_manage_wget => false,
          }'
        end

        it 'should not install wget' do
          should_not contain_package('wget')
        end
      end

      context 'only http enabled' do
        let :pre_condition do
          'class {"foreman_proxy":
            ssl  => false,
            http => true,
          }'
        end

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
        let :pre_condition do
          'class {"foreman_proxy":
            ssl         => true,
            ssl_port    => 867,
            http        => true,
            http_port   => 5309,
          }'
        end

        it 'should configure both http and ssl on their respective ports' do
          verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.yml", [
            ':https_port: 867',
            ':http_port: 5309',
          ])
        end
      end

      context 'when dns_provider => libvirt' do
        let :pre_condition do
          'class {"foreman_proxy":
            dns_provider => "libvirt",
            libvirt_network => "mynet",
            libvirt_connection => "http://myvirt",
          }'
        end

        it 'should set the provider correctly' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/dns.yml", [
            '---',
            ':enabled: false',
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

      context 'when dns_provider => nsupdate_gss' do
        let :pre_condition do
          'class {"foreman_proxy":
            dns_provider => "nsupdate_gss",
          }'
        end

        it 'should contain dns_tsig_* settings' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/dns.yml", [
            '---',
            ':enabled: false',
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

      context 'when dhcp_provider => libvirt' do
        let :pre_condition do
          'class {"foreman_proxy":
            dhcp_provider       => "libvirt",
            libvirt_network    => "mynet",
            libvirt_connection => "http://myvirt",
          }'
        end

        it 'should set the provider correctly' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/dhcp.yml", [
            '---',
            ':enabled: false',
            ':use_provider: dhcp_libvirt',
            ':server: 127.0.0.1',
          ])

          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/dhcp_libvirt.yml", [
            '---',
            ':network: mynet',
            ':url: http://myvirt',
          ])
        end
      end

      context 'with puppetrun_provider set to mcollective and user overridden' do
        let :pre_condition do
          'class {"foreman_proxy":
            puppet             => true,
            puppetrun_provider => "mcollective",
            mcollective_user   => "peadmin",
          }'
        end

        it 'should contain mcollective as provider' do
          verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/puppet.yml", [
            ':use_provider: puppet_proxy_mcollective',
          ])
        end

        it 'should contain user overridden' do
          verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/puppet_proxy_mcollective.yml", [
            ':user: peadmin',
          ])
        end
      end

      context 'when puppetrun_provider => ssh' do
        let :pre_condition do
          'class {"foreman_proxy":
            puppetrun_provider => "ssh",
          }'
        end

        it 'should set provider to puppet_proxy_ssh' do
          verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/puppet.yml", [
            ':use_provider: puppet_proxy_ssh',
          ])
        end
      end

      context 'when puppetrun_provider => ssh and user/key overridden' do
        let :pre_condition do
          'class {"foreman_proxy":
            puppetrun_provider => "ssh",
            puppetssh_user => "example",
            puppetssh_keyfile => "/home/example/.ssh/id_rsa",
          }'
        end

        it 'should set puppetssh_user and puppetssh_keyfile' do
          verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/puppet_proxy_ssh.yml", [
            ':user: example',
            ':keyfile: /home/example/.ssh/id_rsa',
          ])
        end
      end

      context 'when puppetrun_provider => salt and command overridden' do
        let :pre_condition do
          'class {"foreman_proxy":
            puppetrun_provider => "salt",
            salt_puppetrun_cmd => "puppet.run agent no-noop",
          }'
        end

        it 'should contain salt as provider' do
          verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/puppet.yml", [
            ':use_provider: puppet_proxy_salt',
          ])
        end

        it 'should contain salt command overridden' do
          verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/puppet_proxy_salt.yml", [
            ':command: puppet.run agent no-noop',
          ])
        end
      end

      context 'when puppet_use_environment_api set' do
        let :pre_condition do
          'class {"foreman_proxy":
            puppet_use_environment_api => false,
          }'
        end

        it 'should set puppet_use_environment_api' do
          verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/puppet_proxy_legacy.yml", [
            ':use_environment_api: false',
          ])
        end
      end

      context 'with puppet use_cache enabled' do
        let :pre_condition do
          'class {"foreman_proxy":
            puppet_use_cache => true,
          }'
        end

        it 'should set use_cache' do
          verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/puppet_proxy_legacy.yml", [
            ':use_cache: true',
          ])
        end
      end

      context 'when trusted_hosts is empty' do
        let :pre_condition do
          'class {"foreman_proxy":
            trusted_hosts => [],
          }'
        end

        it 'should not set trusted_hosts' do
          should contain_file("#{etc_dir}/foreman-proxy/settings.yml").without_content(/[^#]:trusted_hosts/)
        end
      end

      context 'with custom foreman_base_url' do
        let :pre_condition do
          'class {"foreman_proxy":
             foreman_base_url => "http://dummy",
           }'
        end

        it 'should generate foreman_url setting' do
          content = catalogue.resource('file', "#{etc_dir}/foreman-proxy/settings.yml").send(:parameters)[:content]
          content.split("\n").select { |c| c =~ /foreman_url/ }.should == [':foreman_url: http://dummy']
        end
      end

      context 'when puppetca_cmd set' do
        let :pre_condition do
          'class { "foreman_proxy":
            puppetca_cmd => "puppet cert",
          }'
        end

        it "should set puppetca_cmd" do
          verify_exact_contents(catalogue, "#{etc_dir}/sudoers.d/foreman-proxy", [
            "#{proxy_user_name} ALL = (root) NOPASSWD : puppet cert *",
            "#{proxy_user_name} ALL = (root) NOPASSWD : #{puppetrun_command}",
            "Defaults:#{proxy_user_name} !requiretty",
          ])
        end
      end

      context 'when puppetrun_cmd set' do
        let :pre_condition do
          'class { "foreman_proxy":
            puppetrun_cmd => "mco puppet runonce",
          }'
        end

        it "should set puppetrun_cmd" do
          verify_exact_contents(catalogue, "#{etc_dir}/sudoers.d/foreman-proxy", [
            "#{proxy_user_name} ALL = (root) NOPASSWD : #{puppetca_command}",
            "#{proxy_user_name} ALL = (root) NOPASSWD : mco puppet runonce *",
            "Defaults:#{proxy_user_name} !requiretty",
          ])
        end
      end

      context 'when puppet_user set' do
        let :pre_condition do
          'class { "foreman_proxy":
            puppet_user => "some_puppet_user",
          }'
        end

        it "should set puppetrun_cmd" do
          verify_exact_contents(catalogue, "#{etc_dir}/sudoers.d/foreman-proxy", [
            "#{proxy_user_name} ALL = (root) NOPASSWD : #{puppetca_command}",
            "#{proxy_user_name} ALL = (some_puppet_user) NOPASSWD : #{puppetrun_command}",
            "Defaults:#{proxy_user_name} !requiretty",
          ])
        end
      end

      context 'when puppetca disabled' do
        let :pre_condition do
          'class { "foreman_proxy":
            puppetca => false,
          }'
        end

        it "should not set puppetca" do
          verify_exact_contents(catalogue, "#{etc_dir}/sudoers.d/foreman-proxy", [
            "#{proxy_user_name} ALL = (root) NOPASSWD : #{puppetrun_command}",
            "Defaults:#{proxy_user_name} !requiretty",
          ])
        end
      end

      context 'when puppet disabled' do
        let :pre_condition do
          'class { "foreman_proxy":
            puppet => false,
          }'
        end

        it "should not set puppetrun" do
          verify_exact_contents(catalogue, "#{etc_dir}/sudoers.d/foreman-proxy", [
            "#{proxy_user_name} ALL = (root) NOPASSWD : #{puppetca_command}",
            "Defaults:#{proxy_user_name} !requiretty",
          ])
        end
      end

      context 'when puppetca and puppet disabled' do
        let :pre_condition do
          'class { "foreman_proxy":
            puppetca  => false,
            puppet => false,
          }'
        end

        it { should_not contain_file("#{etc_dir}/sudoers.d") }
        it { should_not contain_file("#{etc_dir}/sudoers.d/foreman-proxy") }
      end

      context 'when use_sudoersd => false' do
        let :pre_condition do
          'class {"foreman_proxy":
            use_sudoersd => false,
          }'
        end

        it "should not manage #{etc_dir}/sudoers.d" do
          should_not contain_file("#{etc_dir}/sudoers.d")
        end

        it "should not manage #{etc_dir}/sudoers.d/foreman-proxy" do
          should_not contain_file("#{etc_dir}/sudoers.d/foreman-proxy")
        end

        it "should modify #{etc_dir}/sudoers" do
          should contain_augeas('sudo-foreman-proxy').with({
            :context  => "/files#{etc_dir}/sudoers",
          })

          changes = catalogue.resource('augeas', 'sudo-foreman-proxy').send(:parameters)[:changes]
          changes.split("\n").should == [
            "set spec[user = '#{proxy_user_name}'][1]/user #{proxy_user_name}",
            "set spec[user = '#{proxy_user_name}'][1]/host_group/host ALL",
            "set spec[user = '#{proxy_user_name}'][1]/host_group/command '#{puppetca_command}'",
            "set spec[user = '#{proxy_user_name}'][1]/host_group/command/runas_user root",
            "set spec[user = '#{proxy_user_name}'][1]/host_group/command/tag NOPASSWD",
            "set spec[user = '#{proxy_user_name}'][2]/user #{proxy_user_name}",
            "set spec[user = '#{proxy_user_name}'][2]/host_group/host ALL",
            "set spec[user = '#{proxy_user_name}'][2]/host_group/command '#{puppetrun_command}'",
            "set spec[user = '#{proxy_user_name}'][2]/host_group/command/runas_user root",
            "set spec[user = '#{proxy_user_name}'][2]/host_group/command/tag NOPASSWD",
            "rm spec[user = '#{proxy_user_name}'][1]/host_group/command[position() > 1]",
            "set Defaults[type = ':#{proxy_user_name}']/type :#{proxy_user_name}",
            "set Defaults[type = ':#{proxy_user_name}']/requiretty/negate ''",
          ]
        end

        context 'when puppetca => false' do
          let :pre_condition do
            'class {"foreman_proxy":
              use_sudoersd => false,
              puppetca     => false,
            }'
          end

          it "should modify #{etc_dir}/sudoers for puppetrun only" do
            changes = catalogue.resource('augeas', 'sudo-foreman-proxy').send(:parameters)[:changes]
            changes.split("\n").should == [
              "set spec[user = '#{proxy_user_name}']/user #{proxy_user_name}",
              "set spec[user = '#{proxy_user_name}']/host_group/host ALL",
              "set spec[user = '#{proxy_user_name}']/host_group/command '#{puppetrun_command}'",
              "set spec[user = '#{proxy_user_name}']/host_group/command/runas_user root",
              "set spec[user = '#{proxy_user_name}']/host_group/command/tag NOPASSWD",
              "rm spec[user = '#{proxy_user_name}'][1]/host_group/command[position() > 1]",
              "set Defaults[type = ':#{proxy_user_name}']/type :#{proxy_user_name}",
              "set Defaults[type = ':#{proxy_user_name}']/requiretty/negate ''",
            ]
          end
        end

        context 'when puppet => false' do
          let :pre_condition do
            'class {"foreman_proxy":
              use_sudoersd => false,
              puppet       => false,
            }'
          end

          it "should modify #{etc_dir}/sudoers for puppetca only" do
            changes = catalogue.resource('augeas', 'sudo-foreman-proxy').send(:parameters)[:changes]
            changes.split("\n").should == [
              "set spec[user = '#{proxy_user_name}']/user #{proxy_user_name}",
              "set spec[user = '#{proxy_user_name}']/host_group/host ALL",
              "set spec[user = '#{proxy_user_name}']/host_group/command '#{puppetca_command}'",
              "set spec[user = '#{proxy_user_name}']/host_group/command/runas_user root",
              "set spec[user = '#{proxy_user_name}']/host_group/command/tag NOPASSWD",
              "rm spec[user = '#{proxy_user_name}'][1]/host_group/command[position() > 1]",
              "set Defaults[type = ':#{proxy_user_name}']/type :#{proxy_user_name}",
              "set Defaults[type = ':#{proxy_user_name}']/requiretty/negate ''",
            ]
          end
        end
      end

      context 'with feature on http' do
        let :pre_condition do
          'class {"foreman_proxy":
            templates           => true,
            templates_listen_on => "http",
          }'
        end

        it 'should set enabled to http' do
          verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/templates.yml", [
            ':enabled: http',
          ])
        end
      end

      context 'with feature on https' do
        let :pre_condition do
          'class {"foreman_proxy":
            templates           => true,
            templates_listen_on => "https",
          }'
        end

        it 'should set enabled to https' do
          verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/templates.yml", [
            ':enabled: https',
          ])
        end
      end

      context 'with feature on both' do
        let :pre_condition do
          'class {"foreman_proxy":
            templates           => true,
            templates_listen_on => "both",
          }'
        end

        it 'should set enabled to true' do
          verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/templates.yml", [
            ':enabled: true',
          ])
        end
      end

      context 'when log_level => DEBUG' do
        let :pre_condition do
          'class {"foreman_proxy":
            log_level => "DEBUG",
          }'
        end

        it 'should set log_level to DEBUG in setting.yml' do
          verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.yml", [
            ':log_level: DEBUG',
          ])
        end
      end

      context 'with dhcp enabled' do
        let :facts do
          facts.merge({
            :concat_basedir => '/doesnotexist',
          })
        end

        case facts[:osfamily]
        when 'FreeBSD', 'DragonFly'
          dhcp_interface = 'lo0'
          dhcp_leases    = '/var/db/dhcpd/dhcpd.leases'
          dhcp_config    = "#{etc_dir}/dhcpd.conf"
        when 'Debian'
          dhcp_interface = 'lo'
          dhcp_leases    = '/var/lib/dhcp/dhcpd.leases'
          dhcp_config    = "#{etc_dir}/dhcp/dhcpd.conf"
        else
          dhcp_interface = 'lo'
          dhcp_leases    = '/var/lib/dhcpd/dhcpd.leases'
          dhcp_config    = "#{etc_dir}/dhcp/dhcpd.conf"
        end

        let :pre_condition do
          "class {'foreman_proxy':
            dhcp           => true,
            dhcp_interface => '#{dhcp_interface}',
          }"
        end

        it 'should generate correct dhcp.yml' do
          verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/dhcp.yml", [
            '---',
            ':enabled: https',
            ':use_provider: dhcp_isc',
            ':server: 127.0.0.1',
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
      end

      context 'with ssl_disabled_ciphers' do
        let :pre_condition do
          'class {"foreman_proxy":
            ssl_disabled_ciphers => ["CIPHER-SUITE-1", "CIPHER-SUITE-2"],
          }'
        end

        it 'should set ssl_disabled_ciphers to YAML array in setting.yml' do
          verify_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.yml", [
            ':ssl_disabled_ciphers:',
            '  - CIPHER-SUITE-1',
            '  - CIPHER-SUITE-2',
          ])
        end
      end
      describe 'manage_puppet_group' do
        context 'when puppet and puppetca are false' do
          context 'when manage_puppet_group = true and ssl = true' do
            let :pre_condition do
              'class {"foreman_proxy":
                puppet              => false,
                puppetca            => false,
                manage_puppet_group => true,
                ssl                 => true,
              }'
            end

            it 'manages puppet group' do
              should contain_group('puppet').with_ensure('present').that_comes_before("User[#{proxy_user_name}]")
            end

            it 'sets group ownership to puppet on ssl files' do
              should contain_file("#{var_dir}/ssl").with_group('puppet')
              should contain_file("#{var_dir}/ssl/private_keys").with_group('puppet')
              should contain_file("#{var_dir}/ssl/certs/ca.pem").with_group('puppet')
              should contain_file("#{var_dir}/ssl/certs/#{facts[:fqdn]}.pem").with_group('puppet')
              should contain_file("#{var_dir}/ssl/private_keys/#{facts[:fqdn]}.pem").with_group('puppet')
            end
            context 'when puppet group is already being managed' do
              let :pre_condition do
                'group {"puppet": ensure => present}
                 class {"foreman_proxy":
                  puppet              => false,
                  puppetca            => false,
                  manage_puppet_group => true,
                  ssl                 => true,
                 }'
            end
              it 'does not manage puppet group' do
                should_not contain_group('puppet').with_before("User[#{proxy_user_name}]")
              end
            end
          end
          context 'when manage_puppet_group = true and ssl = false' do
            let :pre_condition do
              'class {"foreman_proxy":
                puppet              => false,
                puppetca            => false,
                manage_puppet_group => true,
                ssl                 => false,
              }'
            end
            it 'does not manage puppet group' do
              should_not contain_group('puppet')
            end
          end
        end
      end
    end
  end
end
