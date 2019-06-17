require 'spec_helper'

describe 'foreman_proxy::plugin::ansible' do

  ['redhat-7-x86_64', 'debian-9-x86_64'].each do |os|
    context "on #{os}" do
      let :facts do
        on_supported_os[os]
      end

      describe 'with default settings' do
        let :pre_condition do
          "include foreman_proxy"
        end

        it { should contain_foreman_proxy__plugin('dynflow') }

        case os
        when 'debian-9-x86_64'
          it 'should include ansible-runner upstream repo' do
            should contain_apt__source('ansible-runner')
              .with_location('https://releases.ansible.com/ansible-runner/deb')
              .with_repos('main')
              .with_key(
                'id' => 'AC48AC71DA695CA15F2D39C4B84E339C442667A9',
                'source' => 'https://releases.ansible.com/keys/RPM-GPG-KEY-ansible-release.pub'
              )
          end
        when 'redhat-7-x86_64'
          it 'should include ansible-runner upstream repo' do
            should contain_yumrepo('ansible-runner')
                   .with_baseurl("https://releases.ansible.com/ansible-runner/rpm/epel-7-x86_64/")
                   .with_gpgcheck(true)
                   .with_gpgkey('https://releases.ansible.com/keys/RPM-GPG-KEY-ansible-release.pub')
                   .with_enabled('1')
          end
        end

        it { should contain_package('ansible-runner').with_ensure('installed') }

        it 'should configure ansible.yml' do
          should contain_file('/etc/foreman-proxy/settings.d/ansible.yml').
            with_content(/:enabled: https/).
            with_content(%r{:ansible_dir: /usr/share/foreman-proxy})
        end

        it 'should configure ansible.cfg' do
          verify_exact_contents(catalogue, '/etc/foreman-proxy/ansible.cfg', [
            '[defaults]',
            'callback_whitelist = foreman',
            'local_tmp = /tmp',
            'host_key_checking = False',
            'stdout_callback = yaml',
            '[callback_foreman]',
            'url = https://foo.example.com',
            'ssl_key = /var/lib/puppet/ssl/private_keys/foo.example.com.pem',
            'ssl_cert = /var/lib/puppet/ssl/certs/foo.example.com.pem',
            'verify_certs = /var/lib/puppet/ssl/certs/ca.pem',
            'roles_path = /etc/ansible/roles:/usr/share/ansible/roles',
            '[ssh_connection]',
            'ssh_args = -o ProxyCommand=none',
          ])
        end
      end

      describe 'with override parameters' do
        let :pre_condition do
          "include foreman_proxy"
        end

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

        it { should contain_foreman_proxy__plugin('dynflow') }

        case os
        when 'debian-9-x86_64'
          it { should_not contain_apt__source('ansible-runner') }
        when 'redhat-7-x86_64'
          it { should_not contain_yumrepo('ansible-runner') }
        end
        it { should contain_package('ansible-runner').with_ensure('installed') }

        it 'should configure ansible.yml' do
          should contain_file('/etc/foreman-proxy/settings.d/ansible.yml').
            with_content(/:enabled: https/).
            with_content(%r{:ansible_dir: /etc/ansible-test}).
            with_content(%r{:working_dir: /tmp/ansible})
        end

        it 'should configure ansible.cfg' do
          verify_exact_contents(catalogue, '/etc/foreman-proxy/ansible.cfg', [
            '[defaults]',
            'callback_whitelist = foreman',
            'local_tmp = /tmp/ansible',
            'host_key_checking = True',
            'stdout_callback = debug',
            '[callback_foreman]',
            'url = https://foo.example.com',
            'ssl_key = /var/lib/puppet/ssl/private_keys/foo.example.com.pem',
            'ssl_cert = /var/lib/puppet/ssl/certs/foo.example.com.pem',
            'verify_certs = /var/lib/puppet/ssl/certs/ca.pem',
            'roles_path = /etc/ansible/roles:/usr/share/ansible/roles',
            '[ssh_connection]',
            'ssh_args = -o ProxyCommand=none',
          ])
        end
      end
    end
  end
end
