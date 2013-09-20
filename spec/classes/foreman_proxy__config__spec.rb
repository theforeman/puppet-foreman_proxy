require 'spec_helper'

describe 'foreman_proxy::config' do
  let :facts do
    {
      :fqdn                   => 'host.example.org',
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
        :shell   => '/sbin/nologin',
        :comment => 'Foreman Proxy account',
        :groups  => ['puppet'],
        :home    => '/usr/share/foreman-proxy',
        :require => 'Class[Foreman_proxy::Install]',
        :notify  => 'Class[Foreman_proxy::Service]',
      })
    end

    it 'should create the configuration' do
      should contain_file('/etc/foreman-proxy/settings.yml').
        with_content(%r{^:ssl_ca_file: /var/lib/puppet/ssl/certs/ca.pem$}).
        with_content(%r{^:ssl_certificate: /var/lib/puppet/ssl/certs/#{facts[:fqdn]}.pem$}).
        with_content(%r{^:ssl_private_key: /var/lib/puppet/ssl/private_keys/#{facts[:fqdn]}.pem$}).
        with_content(%r{^:port: 8443$}).
        with_content(%r{^:tftp: true$}).
        with_content(%r{^:tftproot: /var/lib/tftpboot/$}).
        with_content(%r{^:tftp_servername: 127\.0\.1\.1$}).
        with_content(%r{^:dns: false$}).
        with_content(%r{^:dns_server: 127\.0\.0\.1$}).
        with_content(%r{^:dhcp: false$}).
        with_content(%r{^:puppetca: true$}).
        with_content(%r{^:ssldir: /var/lib/puppet/ssl$}).
        with_content(%r{^:puppetdir: /etc/puppet$}).
        with_content(%r{^:puppet: true$}).
        with_content(%r{^:puppet_conf: /etc/puppet/puppet.conf$}).
        with_content(%r{^:bmc: false$}).
        with_content(%r{^:bmc_default_provider: freeipmi$}).
        with_content(%r{^:log_file: /var/log/foreman-proxy/proxy.log$}).
        with({
          :owner   => 'foreman-proxy',
          :group   => 'foreman-proxy',
          :mode    => '0644',
          :require => 'Class[Foreman_proxy::Install]',
          :notify  => 'Class[Foreman_proxy::Service]',
        })
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
      should contain_file('/etc/foreman-proxy/settings.yml').
        with_content(%r{^:bmc: true$}).
        with_content(%r{^:bmc_default_provider: shell$}).
        with({})
    end
  end
end
