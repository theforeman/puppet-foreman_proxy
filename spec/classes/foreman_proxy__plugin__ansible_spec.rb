require 'spec_helper'

describe 'foreman_proxy::plugin::ansible' do

  let :facts do
    on_supported_os['redhat-7-x86_64']
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
  end

  describe 'with override parameters' do
    let :pre_condition do
      "include foreman_proxy"
    end

    let :params do
      {
        :enabled     => true,
        :ansible_dir => '/etc/ansible-test',
        :working_dir => '/tmp'
      }
    end

    it { should contain_foreman_proxy__plugin('dynflow') }

    it 'should configure ansible.yml' do
      should contain_file('/etc/foreman-proxy/settings.d/ansible.yml').
        with_content(/:enabled: https/).
        with_content(%r{:ansible_dir: /etc/ansible-test}).
        with_content(%r{:working_dir: /tmp})
    end
  end
end
