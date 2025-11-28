require 'spec_helper'

describe 'foreman_proxy::plugin::shellhooks' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include foreman_proxy' }

      describe 'with default settings' do
        it { should contain_foreman_proxy__plugin__module('shellhooks') }
        it 'shellhooks.yml should contain the correct configuration' do
          verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/shellhooks.yml', [
            '---',
            ':enabled: https',
            ':directory: /var/lib/foreman-proxy/shellhooks'
          ])
        end
      end

      describe 'with overwritten parameters' do
        let :params do
          { :directory => '/opt/custom_shellhooks' }
        end

        it 'shellhooks.yml should contain the correct configuration' do
          verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/shellhooks.yml', [
            '---',
            ':enabled: https',
            ':directory: /opt/custom_shellhooks',
          ])
        end
      end
    end
  end
end
