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
            with_content(%r{:ansible_dir: /etc/ansible})
        end

        it 'should configure ansible.cfg' do
          should contain_file('/usr/share/foreman-proxy/.ansible.cfg').
            with_content(%r{[default]}).
            with_content(%r{callback_whitelist = foreman}).
            with_content(%r{local_tmp = /tmp})
        end
      end

      describe 'with override parameters' do
        let :pre_condition do
          "include foreman_proxy"
        end

        let :params do
          {
            :enabled     => true,
            :ansible_dir => '/etc/ansible-test',
            :working_dir => '/tmp/ansible'
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
          should contain_file('/usr/share/foreman-proxy/.ansible.cfg').
            with_content(%r{[default]}).
            with_content(%r{callback_whitelist = foreman}).
            with_content(%r{local_tmp = /tmp/ansible})
        end
      end
    end
  end
end
