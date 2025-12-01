require 'spec_helper'

describe 'foreman_proxy::plugin::remote_execution::mosquitto' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let :params do {
        :ssl_cert => '/etc/foreman-proxy/ssl_cert.pem',
        :ssl_key => '/etc/foreman-proxy/ssl_key.pem',
        :ssl_ca => '/etc/foreman-proxy/ssl_ca.pem'
      } end

      describe 'with default settings' do
        let(:ciphers_option) { os_facts.dig(:os, 'family') == 'RedHat' ? ['ciphers PROFILE=SYSTEM'] : [] }

        it 'should configure mosquitto' do
          should contain_class('mosquitto').
            with({
              :package_name   => 'mosquitto',
              :package_ensure => 'present',
              :service_ensure => 'running',
              :service_enable => true,
              :config         => [
                'listener 1883',
                'acl_file /etc/mosquitto/foreman.acl',
                'cafile /etc/mosquitto/ssl/ssl_ca.pem',
                'certfile /etc/mosquitto/ssl/ssl_cert.pem',
                'keyfile /etc/mosquitto/ssl/ssl_key.pem',
                'require_certificate true',
                'use_identity_as_username true'
              ] + ciphers_option
            })
        end

        it 'should configure an ACL file' do
          should contain_file('/etc/mosquitto/foreman.acl').
            with_content(%r{pattern read yggdrasil/%u/data/in}).
            with_content(%r{pattern write yggdrasil/%u/control/out}).
            with_content(%r{user #{facts['fqdn']}}).
            with_content(%r{topic write yggdrasil/\+/data/in}).
            with_content(%r{topic read yggdrasil/\+/control/out}).
            with({
              :ensure  => 'present',
              :owner   => 'root',
              :group   => 'mosquitto',
              :mode    => '0640',
              :notify  => 'Class[Mosquitto::Service]',
            })
        end

        it 'should configure a SSL directory' do
          should contain_file('/etc/mosquitto/ssl').
            with({
              :ensure => 'directory',
              :owner  => 'root',
              :group  => 'mosquitto',
              :mode   => '0755'
            })
        end

        it 'should configure an ssl_cert' do
          should contain_file('/etc/mosquitto/ssl/ssl_cert.pem').
            with({
              :ensure => 'present',
              :source => '/etc/foreman-proxy/ssl_cert.pem',
              :owner  => 'root',
              :group  => 'mosquitto',
              :mode   => '0440',
              :notify => 'Class[Mosquitto::Service]',
            })
        end

        it 'should configure an ssl_key' do
          should contain_file('/etc/mosquitto/ssl/ssl_key.pem').
            with({
              :ensure => 'present',
              :source => '/etc/foreman-proxy/ssl_key.pem',
              :owner  => 'root',
              :group  => 'mosquitto',
              :mode   => '0440',
              :notify => 'Class[Mosquitto::Service]',
            })
        end

        it 'should configure an ssl_ca' do
          should contain_file('/etc/mosquitto/ssl/ssl_ca.pem').
            with({
              :ensure  => 'present',
              :source  => '/etc/foreman-proxy/ssl_ca.pem',
              :owner   => 'root',
              :group   => 'mosquitto',
              :mode    => '0440',
              :notify  => 'Class[Mosquitto::Service]',
            })
        end
      end

      describe 'with certs deployed by puppet' do
        let(:pre_condition) do
          <<-PUPPET
          file { '/etc/foreman-proxy/ssl_cert.pem': ensure => file }
          file { '/etc/foreman-proxy/ssl_key.pem': ensure => file }
          file { '/etc/foreman-proxy/ssl_ca.pem': ensure => file }
          PUPPET
        end

        it 'should notify mosquitto certs when source changes' do
          should contain_file('/etc/foreman-proxy/ssl_cert.pem').that_notifies('File[/etc/mosquitto/ssl/ssl_cert.pem]')
          should contain_file('/etc/foreman-proxy/ssl_key.pem').that_notifies('File[/etc/mosquitto/ssl/ssl_key.pem]')
          should contain_file('/etc/foreman-proxy/ssl_ca.pem').that_notifies('File[/etc/mosquitto/ssl/ssl_ca.pem]')
        end
      end

      describe 'with certs deployed by puppet as custom types' do
        let(:pre_condition) do
          <<-PUPPET
          define private_key () { file { $name: ensure => file } }

          private_key { '/etc/foreman-proxy/ssl_key.pem': }
          PUPPET
        end

        it 'should notify mosquitto certs when source changes' do
          should contain_private_key('/etc/foreman-proxy/ssl_key.pem').that_notifies('File[/etc/mosquitto/ssl/ssl_key.pem]')
        end
      end

      describe '' do
        let(:params) { super().merge(:ensure => 'absent') }

        it 'should configure mosquitto' do
          should contain_class('mosquitto').
            with({
              :package_ensure => 'absent',
              :service_ensure => 'stopped',
              :service_enable => false,
            })
        end

        it 'should configure an ACL file' do
          should contain_file('/etc/mosquitto/foreman.acl').
            with({
              :ensure => 'absent',
            })
        end

        it 'should configure a SSL directory' do
          should contain_file('/etc/mosquitto/ssl').
            with({
              :ensure => 'absent',
            })
        end

        it 'should configure an ssl_cert' do
          should contain_file('/etc/mosquitto/ssl/ssl_cert.pem').
            with({
              :ensure => 'absent',
            })
        end

        it 'should configure an ssl_key' do
          should contain_file('/etc/mosquitto/ssl/ssl_key.pem').
            with({
              :ensure => 'absent',
            })
        end

        it 'should configure an ssl_ca' do
          should contain_file('/etc/mosquitto/ssl/ssl_ca.pem').
            with({
              :ensure => 'absent',
            })
        end
      end
    end
  end
end
