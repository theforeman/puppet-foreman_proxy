require 'spec_helper'

describe 'foreman_proxy::plugin::remote_execution::script' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include foreman_proxy' }

      describe 'with default settings' do
        it { should contain_class('foreman_proxy::plugin::dynflow') }
        it { should contain_foreman_proxy__plugin__module('remote_execution_ssh') }

        it 'should configure remote_execution_ssh.yml' do
          should contain_file('/etc/foreman-proxy/settings.d/remote_execution_ssh.yml').
            with_content(/^:enabled: https/).
            with_content(%r{:ssh_identity_key_file: /var/lib/foreman-proxy/ssh/id_rsa_foreman_proxy}).
            with_content(%r{:kerberos_auth: false}).
            without_content(%r{:ssh_log_level:}).
            with_content(%r{:cockpit_integration: true}).
            with({
              :ensure  => 'file',
              :owner   => 'root',
              :mode    => '0640'
            })
        end

        it 'should configure ssh key' do
          should contain_exec('generate_ssh_key').
            with_command("/usr/bin/ssh-keygen -f /var/lib/foreman-proxy/ssh/id_rsa_foreman_proxy -N '' -m pem")
        end

        it { should_not contain_file('/root/.ssh') }

        it 'should ensure absent mosquitto' do
          should contain_class('foreman_proxy::plugin::remote_execution::mosquitto').
            with({
              :ensure => 'absent',
            })
        end

        it 'should configure before mosquitto' do
          should contain_class('foreman_proxy::config').that_notifies('Class[foreman_proxy::plugin::remote_execution::mosquitto]')
        end
      end

      describe 'with override parameters' do
        let :params do {
          :enabled            => true,
          :listen_on          => 'http',
          :local_working_dir  => '/tmp',
          :remote_working_dir => '/tmp',
          :generate_keys      => false,
          :ssh_identity_dir   => '/usr/share/foreman-proxy/.ssh-rex',
          :ssh_identity_file  => 'id_rsa',
          :install_key        => true,
          :ssh_kerberos_auth  => true,
          :mode               => 'pull-mqtt',
          :ssh_log_level      => 'debug',
          :cockpit_integration => false,
        } end

        it { should contain_class('foreman_proxy::plugin::dynflow') }
        it { should contain_foreman_proxy__plugin__module('remote_execution_ssh') }

        it 'should configure remote_execution_ssh.yml' do
          should contain_file('/etc/foreman-proxy/settings.d/remote_execution_ssh.yml').
            with_content(/^:enabled: http/).
            with_content(%r{:ssh_identity_key_file: /usr/share/foreman-proxy/.ssh-rex/id_rsa}).
            with_content(%r{:local_working_dir: /tmp}).
            with_content(%r{:remote_working_dir: /tmp}).
            with_content(%r{:kerberos_auth: true}).
            with_content(%r{:mode: pull-mqtt}).
            with_content(%r{:ssh_log_level: debug}).
            with_content(%r{:cockpit_integration: false}).
            with({
              :ensure  => 'file',
              :owner   => 'root',
              :mode    => '0640'
            })
        end

        it { should_not contain_exec('generate_ssh_key') }
        it { should_not contain_file('/root/.ssh') }
      end

      describe 'with ssh key generating and installation' do
        let :params do {
          :enabled            => true,
          :listen_on          => 'http',
          :local_working_dir  => '/tmp',
          :remote_working_dir => '/tmp',
          :generate_keys      => true,
          :ssh_identity_dir   => '/usr/share/foreman-proxy/.ssh-rex',
          :ssh_identity_file  => 'id_rsa',
          :install_key        => true,
        } end

        it { should contain_exec('generate_ssh_key') }
        it { should contain_file('/root/.ssh') }
      end

      describe 'with pull-mqtt mode' do
        let :params do {
          :mode => 'pull-mqtt',
        } end

        it { should contain_foreman_proxy__plugin__module('remote_execution_ssh') }

        it 'should configure remote_execution_ssh.yml' do
          should contain_file('/etc/foreman-proxy/settings.d/remote_execution_ssh.yml').
            with_content(%r{:mode: pull-mqtt}).
            with_content(%r{:mqtt_port: 1883}).
            with_content(%r{:mqtt_broker: #{facts['fqdn']}})
        end

        it 'should ensure present mosquitto' do
          should contain_class('foreman_proxy::plugin::remote_execution::mosquitto').
            with({
              :ensure => 'present',
            })
        end

        it 'should configure before mosquitto' do
          should contain_class('foreman_proxy::config').that_notifies('Class[foreman_proxy::plugin::remote_execution::mosquitto]')
        end
      end
    end
  end
end
