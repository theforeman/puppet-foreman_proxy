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
                   .with_baseurl("https://releases.ansible.com/ansible-runner/rpm/epel-7-$basearch/")
                   .with_gpgcheck(true)
                   .with_gpgkey('https://releases.ansible.com/keys/RPM-GPG-KEY-ansible-release.pub')
                   .with_enabled('1')
                   .that_comes_before('Package[ansible-runner]')
          end
          it { should contain_package('ansible-runner').with_ensure('installed') }
        end


        it 'should configure ansible.yml' do
          should contain_file('/etc/foreman-proxy/settings.d/ansible.yml').
            with_content(/:enabled: https/).
            with_content(%r{:ansible_dir: /usr/share/foreman-proxy})
        end

        it 'should configure ansible.cfg' do
          callback = facts[:os]['family'] == 'RedHat' ? 'theforeman.foreman.foreman' : 'foreman'
          verify_exact_contents(catalogue, '/etc/foreman-proxy/ansible.cfg', [
            '[defaults]',
            "callback_whitelist = #{callback}",
            'local_tmp = /tmp',
            'host_key_checking = False',
            'stdout_callback = yaml',
            '[callback_foreman]',
            'url = https://foo.example.com',
            'ssl_key = /etc/puppetlabs/puppet/ssl/private_keys/foo.example.com.pem',
            'ssl_cert = /etc/puppetlabs/puppet/ssl/certs/foo.example.com.pem',
            'verify_certs = /etc/puppetlabs/puppet/ssl/certs/ca.pem',
            'roles_path = /etc/ansible/roles:/usr/share/ansible/roles',
            'collections_paths = /etc/ansible/collections:/usr/share/ansible/collections',
            '[ssh_connection]',
            'ssh_args = -o ProxyCommand=none -C -o ControlMaster=auto -o ControlPersist=60s',
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
            stdout_callback: 'debug',
            manage_runner_repo: false,
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

        it 'should configure ansible.cfg' do
          callback = facts[:os]['family'] == 'RedHat' ? 'theforeman.foreman.foreman' : 'foreman'
          verify_exact_contents(catalogue, '/etc/foreman-proxy/ansible.cfg', [
            '[defaults]',
            "callback_whitelist = #{callback}",
            'local_tmp = /tmp/ansible',
            'host_key_checking = True',
            'stdout_callback = debug',
            '[callback_foreman]',
            'url = https://foo.example.com',
            'ssl_key = /etc/puppetlabs/puppet/ssl/private_keys/foo.example.com.pem',
            'ssl_cert = /etc/puppetlabs/puppet/ssl/certs/foo.example.com.pem',
            'verify_certs = /etc/puppetlabs/puppet/ssl/certs/ca.pem',
            'roles_path = /etc/ansible/roles:/usr/share/ansible/roles',
            'collections_paths = /etc/ansible/collections:/usr/share/ansible/collections',
            '[ssh_connection]',
            'ssh_args = -o ProxyCommand=none -C -o ControlMaster=auto -o ControlPersist=60s',
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
