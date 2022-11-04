require 'spec_helper'

describe 'foreman_proxy::plugin::ansible' do
  on_plugin_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include foreman_proxy' }

      describe 'with default settings' do
        it { should contain_class('foreman_proxy::plugin::dynflow') }
        it { should contain_foreman_proxy__plugin__module('ansible') }

        case os
        when 'debian-11-x86_64'
          it { should contain_package('python3-ansible-runner').with_ensure('installed') }
        when 'redhat-7-x86_64'
          it 'should include ansible-runner upstream repo' do
            should contain_yumrepo('ansible-runner')
                   .with_ensure('absent')
                   .that_comes_before('Package[ansible-runner]')
          end
          it { should contain_package('ansible-runner').with_ensure('installed') }
        end


        it 'should configure ansible.yml' do
          should contain_file('/etc/foreman-proxy/settings.d/ansible.yml').
            with_content(/:enabled: https/).
            with_content(%r{:ansible_dir: /usr/share/foreman-proxy})
        end

        it 'should configure ansible.env' do
          callback = facts[:os]['family'] == 'RedHat' ? 'theforeman.foreman.foreman' : 'foreman'
          verify_exact_contents(catalogue, '/etc/foreman-proxy/ansible.env', [
            "export ANSIBLE_CALLBACK_WHITELIST=\"#{callback}\"",
            "export ANSIBLE_CALLBACKS_ENABLED=\"#{callback}\"",
            'export ANSIBLE_LOCAL_TEMP="/tmp"',
            'export ANSIBLE_HOST_KEY_CHECKING="False"',
            'export ANSIBLE_ROLES_PATH="/etc/ansible/roles:/usr/share/ansible/roles"',
            'export ANSIBLE_COLLECTIONS_PATHS="/etc/ansible/collections:/usr/share/ansible/collections"',
            'export FOREMAN_URL="https://foo.example.com"',
            'export FOREMAN_SSL_KEY="/etc/puppetlabs/puppet/ssl/private_keys/foo.example.com.pem"',
            'export FOREMAN_SSL_CERT="/etc/puppetlabs/puppet/ssl/certs/foo.example.com.pem"',
            'export FOREMAN_SSL_VERIFY="/etc/puppetlabs/puppet/ssl/certs/ca.pem"',
            'export ANSIBLE_SSH_ARGS="-o ProxyCommand=none -C -o ControlMaster=auto -o ControlPersist=60s"',
          ])
        end
      end

      describe 'with override parameters' do
        let :params do
          {
            enabled: true,
            ansible_dir: '/etc/ansible-test',
            working_dir: '/tmp/ansible',
            host_key_checking: true,
          }
        end

        it { should contain_class('foreman_proxy::plugin::dynflow') }

        case os
        when 'debian-10-x86_64'
          it { should_not contain_apt__source('ansible-runner') }
          it { should contain_package('python3-ansible-runner').with_ensure('installed') }
        when 'redhat-7-x86_64'
          it { should_not contain_yumrepo('ansible-runner') }
          it { should contain_package('ansible-runner').with_ensure('installed') }
        end

        it 'should configure ansible.yml' do
          should contain_file('/etc/foreman-proxy/settings.d/ansible.yml').
            with_content(/:enabled: https/).
            with_content(%r{:ansible_dir: /etc/ansible-test}).
            with_content(%r{:working_dir: /tmp/ansible})
        end

        it 'should configure ansible.env' do
          callback = facts[:os]['family'] == 'RedHat' ? 'theforeman.foreman.foreman' : 'foreman'
          verify_exact_contents(catalogue, '/etc/foreman-proxy/ansible.env', [
            "export ANSIBLE_CALLBACK_WHITELIST=\"#{callback}\"",
            "export ANSIBLE_CALLBACKS_ENABLED=\"#{callback}\"",
            'export ANSIBLE_LOCAL_TEMP="/tmp/ansible"',
            'export ANSIBLE_HOST_KEY_CHECKING="True"',
            'export ANSIBLE_ROLES_PATH="/etc/ansible/roles:/usr/share/ansible/roles"',
            'export ANSIBLE_COLLECTIONS_PATHS="/etc/ansible/collections:/usr/share/ansible/collections"',
            'export FOREMAN_URL="https://foo.example.com"',
            'export FOREMAN_SSL_KEY="/etc/puppetlabs/puppet/ssl/private_keys/foo.example.com.pem"',
            'export FOREMAN_SSL_CERT="/etc/puppetlabs/puppet/ssl/certs/foo.example.com.pem"',
            'export FOREMAN_SSL_VERIFY="/etc/puppetlabs/puppet/ssl/certs/ca.pem"',
            'export ANSIBLE_SSH_ARGS="-o ProxyCommand=none -C -o ControlMaster=auto -o ControlPersist=60s"',
          ])
        end
      end

      describe 'with disabled ansible-runner install' do
        let :params do
          { install_runner: false }
        end

        it 'should not contain ansible-runner' do
          should_not contain_class('foreman_proxy::plugin::ansible::runner')
          should_not contain_apt__source('ansible-runner')
          should_not contain_yumrepo('ansible-runner')
          should_not contain_package('ansible-runner')
          should_not contain_package('python3-ansible-runner')
        end
      end
    end
  end
end
