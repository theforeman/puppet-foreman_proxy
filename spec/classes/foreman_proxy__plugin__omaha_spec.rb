require 'spec_helper'

describe 'foreman_proxy::plugin::omaha' do

  let :facts do
    on_supported_os['redhat-7-x86_64']
  end

  describe 'with default settings' do
    let :pre_condition do
      "include foreman_proxy"
    end

    it { should contain_foreman_proxy__plugin('omaha') }
    it 'omaha.yml should contain the correct configuration' do
      verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/omaha.yml', [
        '---',
        ':enabled: https',
        ":contentpath: '/var/lib/foreman-proxy/omaha/content'",
        ':sync_releases: 2'
      ])
    end
  end

  describe 'with overwritten parameters' do
    let :pre_condition do
      "include foreman_proxy"
    end
    let :params do {
      :contentpath => '/tmp',
      :sync_releases => 5,
      :http_proxy => 'http://myproxy.example.com:8000/',
    } end

    it 'omaha.yml should contain the correct configuration' do
      verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/omaha.yml', [
        '---',
        ':enabled: https',
        ":contentpath: '/tmp'",
        ':sync_releases: 5',
        ":proxy: 'http://myproxy.example.com:8000/'",
      ])
    end
  end

  describe 'with group overridden' do
    let :pre_condition do
      "include foreman_proxy"
    end
    let :params do {
      :group => 'example',
    } end

    it 'should change omaha.yml group' do
      should contain_file('/etc/foreman-proxy/settings.d/omaha.yml').
        with({
          :owner   => 'root',
          :group   => 'example'
        })
    end
  end
end
