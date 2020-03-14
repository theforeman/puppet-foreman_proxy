require 'spec_helper'

describe 'foreman_proxy::plugin::remote_execution::ssh' do
  on_plugin_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include foreman_proxy' }
      let(:package_name) { os.start_with?('debian') ? 'ruby-net-ssh-krb' : 'tfm-rubygem-net-ssh-krb' }

      describe 'with default settings' do
        it { should contain_foreman_proxy__plugin('dynflow') }
        it { should contain_foreman_proxy__plugin('remote_execution_ssh') }

        it 'should configure remote_execution_ssh.yml' do
          should contain_file('/etc/foreman-proxy/settings.d/remote_execution_ssh.yml').
            with_content(/^:enabled: https/).
            with_content(%r{:ssh_identity_key_file: /var/lib/foreman-proxy/ssh/id_rsa_foreman_proxy}).
            with_content(%r{:kerberos_auth: false}).
            with({
              :ensure  => 'file',
              :owner   => 'root',
              :mode    => '0640'
            })
        end

        it 'should configure ssh key' do
          should contain_exec('generate_ssh_key').
            with_command("/usr/bin/ssh-keygen -f /var/lib/foreman-proxy/ssh/id_rsa_foreman_proxy -N ''")
        end

        it { should_not contain_file('/root/.ssh') }
        it { should_not contain_package(package_name) }
      end

      describe 'with override parameters' do
        let :params do {
          :enabled            => true,
          :local_working_dir  => '/tmp',
          :remote_working_dir => '/tmp',
          :generate_keys      => false,
          :ssh_identity_dir   => '/usr/share/foreman-proxy/.ssh-rex',
          :ssh_identity_file  => 'id_rsa',
          :install_key        => true,
          :ssh_kerberos_auth  => true,
          :async_ssh          => true,
        } end

        it { should contain_foreman_proxy__plugin('dynflow') }
        it { should contain_foreman_proxy__plugin('remote_execution_ssh') }

        it 'should configure remote_execution_ssh.yml' do
          should contain_file('/etc/foreman-proxy/settings.d/remote_execution_ssh.yml').
            with_content(/^:enabled: http/).
            with_content(%r{:ssh_identity_key_file: /usr/share/foreman-proxy/.ssh-rex/id_rsa}).
            with_content(%r{:local_working_dir: /tmp}).
            with_content(%r{:remote_working_dir: /tmp}).
            with_content(%r{:kerberos_auth: true}).
            with_content(%r{:async_ssh: true}).
            with({
              :ensure  => 'file',
              :owner   => 'root',
              :mode    => '0640'
            })
        end

        it { should_not contain_exec('generate_ssh_key') }
        it { should_not contain_file('/root/.ssh') }
        it { should contain_package(package_name) }
      end

      describe 'with ssh key generating and installation' do
        let :params do {
          :enabled            => true,
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
    end
  end
end
