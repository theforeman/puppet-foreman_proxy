require 'spec_helper'

describe 'foreman_proxy::config' do
  let :facts do
    {
      :fqdn                   => 'host.example.org',
      :domain                 => 'example.org',
      :ipaddress_eth0         => '127.0.1.1',
      :operatingsystem        => 'RedHat',
      :operatingsystemrelease => '6',
      :osfamily               => 'RedHat',
    }
  end

  context 'without parameters' do
    let :pre_condition do
      'class {"foreman_proxy":}'
    end

    it 'should include puppetca' do
      should contain_class('foreman_proxy::puppetca')
    end

    it 'should include tftp' do
      should contain_class('foreman_proxy::tftp')
    end

    it 'should not include dns' do
      should_not contain_class('foreman_proxy::proxydns')
    end

    it 'should not include dhcp' do
      should_not contain_class('foreman_proxy::proxydhcp')
    end

    it 'should create the foreman-proxy user' do
      should contain_user('foreman-proxy').with({
        :ensure  => 'present',
        :shell   => '/bin/false',
        :comment => 'Foreman Proxy account',
        :groups  => ['puppet'],
        :home    => '/usr/share/foreman-proxy',
        :require => 'Class[Foreman_proxy::Install]',
        :notify  => 'Class[Foreman_proxy::Service]',
      })
    end

    it 'should create the configuration' do
      should contain_file('/etc/foreman-proxy/settings.yml').
        with({
          :owner   => 'foreman-proxy',
          :group   => 'foreman-proxy',
          :mode    => '0644',
          :require => 'Class[Foreman_proxy::Install]',
          :notify  => 'Class[Foreman_proxy::Service]',
        })
    end

    it do
      content = subject.resource('file', '/etc/foreman-proxy/settings.yml').send(:parameters)[:content]
      content.split("\n").reject { |c| c =~ /(^#|^$)/ }.should == [
        '---',
        ':ssl_ca_file: /var/lib/puppet/ssl/certs/ca.pem',
        ":ssl_certificate: /var/lib/puppet/ssl/certs/#{facts[:fqdn]}.pem",
        ":ssl_private_key: /var/lib/puppet/ssl/private_keys/#{facts[:fqdn]}.pem",
        ':daemon: true',
        ':daemon_pid: /var/run/foreman-proxy/foreman-proxy.pid',
        ':port: 8443',
        ':tftp: true',
        ':tftproot: /var/lib/tftpboot/',
        ':tftp_servername: 127.0.1.1',
        ':dns: false',
        ':dns_provider: nsupdate',
        ':dns_key: /etc/rndc.key',
        ':dns_server: 127.0.0.1',
        ':dns_ttl: 86400',
        ':dhcp: false',
        ':dhcp_vendor: isc',
        ':virsh_network: default',
        ':puppetca: true',
        ':ssldir: /var/lib/puppet/ssl',
        ':puppetdir: /etc/puppet',
        ':puppet: true',
        ':puppet_conf: /etc/puppet/puppet.conf',
        ':customrun_cmd: /bin/false',
        ':customrun_args: -ay -f -s',
        ':puppetssh_sudo: false',
        ':puppetssh_command: /usr/bin/puppet agent --onetime --no-usecacheonfailure',
        ':bmc: false',
        ':bmc_default_provider: ipmitool',
        ':realm: false',
        ':realm_provider: freeipa',
        ':realm_keytab: /etc/foreman-proxy/freeipa.keytab',
        ':realm_principal: realm-proxy@EXAMPLE.COM',
        ':freeipa_remove_dns: true',
        ':log_file: /var/log/foreman-proxy/proxy.log',
      ]
    end

    it 'should set up sudo rules' do
      should contain_file('/etc/sudoers.d').with_ensure('directory')


      should contain_file('/etc/sudoers.d/foreman-proxy').with({
        :ensure  => 'present',
        :owner   => 'root',
        :group   => 'root',
        :mode    => '0440',
        :content => "foreman-proxy ALL = NOPASSWD : /usr/sbin/puppetca *, /usr/sbin/puppetrun *\nDefaults:foreman-proxy !requiretty\n",
        :require => 'File[/etc/sudoers.d]',
      })
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
      verify_contents(subject, '/etc/foreman-proxy/settings.yml', [
        ':bmc: true',
        ':bmc_default_provider: shell',
      ])
    end
  end

  context 'with TFTP and no $ipaddress_eth0 fact' do
    let :facts do
      {
        :fqdn                   => 'host.example.org',
        :ipaddress              => '127.0.1.2',
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '6',
        :osfamily               => 'RedHat',
      }
    end

    let :pre_condition do
      'class {"foreman_proxy":
        tftp => true,
      }'
    end

    it 'should set tftp_servername to $ipaddress' do
      verify_contents(subject, '/etc/foreman-proxy/settings.yml', [
        ':tftp: true',
        ':tftp_servername: 127.0.1.2',
      ])
    end
  end

  context 'with pupppetrun_provider set to mcollective' do
    let :facts do
      {
        :fqdn                   => 'host.example.org',
        :ipaddress              => '127.0.1.2',
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '6',
        :osfamily               => 'RedHat',
      }
    end

    let :pre_condition do
      'class {"foreman_proxy":
        puppetrun          => true,
        puppetrun_provider => "mcollective",
      }'
    end

    it 'should contain mcollective as puppet_provider and puppet_user as root' do
      verify_contents(subject, '/etc/foreman-proxy/settings.yml', [
        ':puppet_provider: mcollective',
        ':puppet_user: root',
      ])
    end
  end

  context 'ssl disabled' do
    let :pre_condition do
      'class {"foreman_proxy":
        ssl => false,
      }'
    end

    it 'should comment out ssl configuration files' do
      verify_contents(subject, '/etc/foreman-proxy/settings.yml', [
        '#:ssl_ca_file: ssl/certs/ca.pem',
        '#:ssl_certificate: ssl/certs/fqdn.pem',
        '#:ssl_private_key: ssl/private_keys/fqdn.key',
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
      verify_contents(subject, '/etc/foreman-proxy/settings.yml', [
        ':dns_tsig_keytab: /etc/foreman-proxy/dns.keytab',
        ':dns_tsig_principal: foremanproxy/host.example.org@EXAMPLE.ORG',
      ])
    end
  end

  context 'when puppetrun_provider => puppetrun' do
    let :pre_condition do
      'class {"foreman_proxy":
        puppetrun_provider => "puppetrun",
      }'
    end

    it 'should contain puppetrun as puppet_provider and puppet_user as root' do
      verify_contents(subject, '/etc/foreman-proxy/settings.yml', [
        ':puppet_provider: puppetrun',
        ':puppet_user: root',
      ])
    end
  end

  context 'when puppetrun_provider => puppetssh' do
    let :pre_condition do
      'class {"foreman_proxy":
        puppetrun_provider => "puppetssh",
      }'
    end

    it 'should set puppetssh_user and puppetssh_keyfile' do
      verify_contents(subject, '/etc/foreman-proxy/settings.yml', [
        ':puppetssh_user: root',
        ':puppetssh_keyfile: /etc/foreman-proxy/id_rsa',
      ])
    end
  end
end
