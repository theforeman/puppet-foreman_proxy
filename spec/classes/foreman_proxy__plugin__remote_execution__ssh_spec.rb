require 'spec_helper'

describe 'foreman_proxy::plugin::remote_execution::ssh' do

  let :facts do
    on_supported_os['redhat-7-x86_64']
  end

  describe 'with default settings' do
    let :pre_condition do
      "include foreman_proxy"
    end

    it { should contain_foreman_proxy__plugin('dynflow') }
    it { should contain_foreman_proxy__plugin('remote_execution_ssh') }

    it 'should configure remote_execution_ssh.yml' do
      should contain_file('/etc/foreman-proxy/settings.d/remote_execution_ssh.yml').
        with_content(/^:enabled: https/).
        with_content(%r{:ssh_identity_key_file: /usr/share/foreman-proxy/.ssh/id_rsa_foreman_proxy}).
        with_content(/^:ssh_user: root/).
        with({
          :ensure  => 'file',
          :owner   => 'root',
          :mode    => '0640'
        })
    end

    it 'should configure ssh key' do
      should contain_exec('generate_ssh_key').
        with({
          :command => "/usr/bin/ssh-keygen -f /usr/share/foreman-proxy/.ssh/id_rsa_foreman_proxy -N ''"
        })
    end
  end

  describe 'with override parameters' do
    let :pre_condition do
      "include foreman_proxy"
    end

    let :params do {
      :enabled           => true,
      :listen_on         => 'http',
      :generate_keys     => false,
      :ssh_identity_dir  => '/usr/share/foreman-proxy/.ssh-rex',
      :ssh_identity_file => 'id_rsa',
      :ssh_user          => 'foreman'
    } end

    it { should contain_foreman_proxy__plugin('dynflow') }
    it { should contain_foreman_proxy__plugin('remote_execution_ssh') }

    it 'should configure remote_execution_ssh.yml' do
      should contain_file('/etc/foreman-proxy/settings.d/remote_execution_ssh.yml').
        with_content(/^:enabled: http/).
        with_content(%r{:ssh_identity_key_file: /usr/share/foreman-proxy/.ssh-rex/id_rsa}).
        with_content(/^:ssh_user: foreman/).
        with({
          :ensure  => 'file',
          :owner   => 'root',
          :mode    => '0640'
        })
    end

    it { should_not contain_exec('generate_ssh_key') }
  end
end
