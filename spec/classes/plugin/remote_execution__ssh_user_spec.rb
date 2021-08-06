require 'spec_helper'

describe 'foreman_proxy::plugin::remote_execution::ssh_user' do
  on_plugin_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'when Foreman ENC is providing topscope variables' do
        # The ENC parameters aren't really `facts`.
        # In reality they wouldn't appear in the `$facts` hash, but with
        # rspec-puppet `let :facts` is still needed to set them as
        # top-scope variables.
        let :facts do
          super().merge(
            remote_execution_create_user: 'true',
            remote_execution_ssh_user: 'foreman_ssh',
            remote_execution_effective_user_method: 'sudo',
            remote_execution_ssh_keys: [
              'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2f3qnCl0FBVTERe+mh+vKgBr/Cttei/V6Txpt4NVMABb802rce8ARZb/lMlWlA98J7a20hZ3Q4kOJxtJvRTty7TPRi1C5fDlTIUtmjWEoRp+ZgXb6BuBU/pYGx9HRgym9jleqvdcZq5ek59xxuu/KHHRc6Y+UBzfQVcVdMgy3hi13oN/nXN+JBuCHZ6s3IdvlhZ1Xir5qqMVdcg2l5ARnUlEyZ7UPvB2LkNiEHjRcr8z8yVdCASUygzcj8lD1uZl4YzuzbSXFD4reqgXcP2EskWqhXiloPoXUNPFH28nfzAndQ3kAYz0cTKSU/gNxCaYhwU5sFnvULWxkMQy062x3 foreman-proxy@foreman-proxy1.example.com',
              'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2f3qnCl0FBVTERe+mh+vKgBr/Cttei/V6Txpt4NVMABb802rce8ARZb/lMlWlA98J7a20hZ3Q4kOJxtJvRTty7TPRi1C5fDlTIUtmjWEoRp+ZgXb6BuBU/pYGx9HRgym9jleqvdcZq5ek59xxuu/KHHRc6Y+UBzfQVcVdMgy3hi13oN/nXN+JBuCHZ6s3IdvlhZ1Xir5qqMVdcg2l5ARnUlEyZ7UPvB2LkNiEHjRcr8z8yVdCASUygzcj8lD1uZl4YzuzbSXFD4reqgXcP2EskWqhXiloPoXUNPFH28nfzAndQ3kAYz0cTKSU/gNxCaYhwU5sFnvULWxkMQy062x3 foreman-proxy@foreman-proxy2.example.com'
            ]
          )
        end

        it { is_expected.to contain_class('foreman_proxy::plugin::remote_execution::ssh_user') }
        it { is_expected.to contain_user('foreman_ssh').with_home('/home/foreman_ssh') }

        describe 'ssh keys' do
          it { is_expected.to have_ssh_authorized_key_resource_count(2) }
          it { is_expected.to contain_ssh_authorized_key('foreman-proxy@foreman-proxy1.example.com').with(
            ensure: 'present',
            user: 'foreman_ssh',
            type: 'ssh-rsa',
            key: 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC2f3qnCl0FBVTERe+mh+vKgBr/Cttei/V6Txpt4NVMABb802rce8ARZb/lMlWlA98J7a20hZ3Q4kOJxtJvRTty7TPRi1C5fDlTIUtmjWEoRp+ZgXb6BuBU/pYGx9HRgym9jleqvdcZq5ek59xxuu/KHHRc6Y+UBzfQVcVdMgy3hi13oN/nXN+JBuCHZ6s3IdvlhZ1Xir5qqMVdcg2l5ARnUlEyZ7UPvB2LkNiEHjRcr8z8yVdCASUygzcj8lD1uZl4YzuzbSXFD4reqgXcP2EskWqhXiloPoXUNPFH28nfzAndQ3kAYz0cTKSU/gNxCaYhwU5sFnvULWxkMQy062x3',
          )}
        end

        describe 'sudo config' do
          it { is_expected.to contain_sudo__conf('foreman-proxy-rex').with_content("foreman_ssh ALL = (root) NOPASSWD : ALL\nDefaults:foreman_ssh !requiretty\n") }
          it { is_expected.to contain_file('/etc/sudoers.d/foreman_ssh').with_ensure('absent') }
        end
      end

      context 'when Foreman ENC is NOT providing topscope variables' do
        it { is_expected.to contain_class('foreman_proxy::plugin::remote_execution::ssh_user') }
        it { is_expected.not_to contain_user('foreman_ssh') }
        it { is_expected.to have_ssh_authorized_key_resource_count(0) }
        it { is_expected.not_to contain_sudo__conf('foreman_ssh') }
        it { is_expected.not_to contain_file('/etc/sudoers.d/foreman_ssh') }
        it { is_expected.not_to contain_file('/etc/sudoers.d/foreman-proxy-rex') }
      end
    end
  end
end
