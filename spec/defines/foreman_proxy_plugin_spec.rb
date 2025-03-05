require 'spec_helper'

describe 'foreman_proxy::plugin' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'myplugin' }
      let(:pre_condition) { 'include foreman_proxy::params' }

      context 'no parameters' do
        let(:package) do
          if facts[:os]['family'] == 'Debian'
            'ruby-smart-proxy-myplugin'
          else
            'rubygem-smart_proxy_myplugin'
          end
        end

        it 'should install the correct package' do
          should contain_package(package).with_ensure('installed')
        end
      end

      context 'with package parameter' do
        let :params do {
          :package => 'myplugin',
        } end

        it 'should install the correct package' do
          should contain_package('myplugin').with_ensure('installed')
        end
      end

      context 'with version parameter' do
        let :params do {
          :package => 'myplugin',
          :version => 'latest',
        } end

        it 'should install the correct package' do
          should contain_package('myplugin').with_ensure('latest')
        end
      end

      context 'when handling underscores on Red Hat' do
        let :params do {
          :package => 'my_fun_plugin',
        } end

        case os_facts[:os]['family']
        when 'Debian'
          it 'should use hyphens' do
            should contain_package('my-fun-plugin').with_ensure('installed')
          end
        else
          it 'should use underscores' do
            should contain_package('my_fun_plugin').with_ensure('installed')
          end
        end
      end
    end
  end
end
