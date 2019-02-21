require 'spec_helper'

describe 'foreman_proxy::plugin::ansible' do

  ['redhat-7-x86_64', 'debian-8-x86_64'].each do |os|
    context "on #{os}" do
      let :facts do
        on_supported_os[os]
      end

      describe 'with default settings' do
        let :pre_condition do
          "include foreman_proxy"
        end

        it { should contain_foreman_proxy__plugin('dynflow') }

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
          ])
        end
      end

      describe 'with override parameters' do
        let :pre_condition do
          "include foreman_proxy"
        end

        let :params do
          {
            :enabled           => true,
            :ansible_dir       => '/etc/ansible-test',
            :working_dir       => '/tmp/ansible',
            :host_key_checking => true,
            :stdout_callback   => 'debug',
          }
        end

        it { should contain_foreman_proxy__plugin('dynflow') }

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
          ])
        end
      end
    end
  end
end
