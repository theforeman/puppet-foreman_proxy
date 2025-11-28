require 'spec_helper'

describe 'foreman_proxy::plugin::monitoring' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include foreman_proxy' }

      describe 'with default settings' do
        it { should contain_foreman_proxy__plugin__module('monitoring') }
        it 'should configure monitoring.yml' do
          should contain_file('/etc/foreman-proxy/settings.d/monitoring.yml').
            with({
              :ensure  => 'file',
              :owner   => 'root',
              :group   => 'foreman-proxy',
              :mode    => '0640',
              :content => /:enabled: https/
            })
        end
      end

      describe 'with overwritten parameters' do
        let :params do {
          :providers => ['example1', 'example2'],
          :collect_status => false,
        } end

        it 'should change monitoring.yml parameters' do
          should contain_file('/etc/foreman-proxy/settings.d/monitoring.yml').
            with_content(/:use_provider:\n  - monitoring_example1\n  - monitoring_example2/).
            with_content(/collect_status: false/)
        end
      end
    end
  end
end
