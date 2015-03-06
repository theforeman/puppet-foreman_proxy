require 'spec_helper'

describe 'foreman_proxy::plugin::abrt' do

  let :facts do {
    :osfamily               => 'RedHat',
    :operatingsystem        => 'CentOS',
    :operatingsystemrelease => '6.5',
    :fqdn                   => 'my.host.example.com',
  } end

  describe 'with default settings' do
    let :pre_condition do
      "include foreman_proxy"
    end

    it { should contain_foreman_proxy__plugin('abrt') }
    it 'should configure abrt.yml' do
      should contain_file('/etc/foreman-proxy/settings.d/abrt.yml').
        with({
          :ensure  => 'file',
          :owner   => 'root',
          :group   => 'foreman-proxy',
          :mode    => '0640',
          :content => /:enabled: https/
        })
    end
  end

  describe 'with group overridden' do
    let :pre_condition do
      "include foreman_proxy"
    end
    let :params do {
      :group => 'example',
    } end

    it 'should change abrt.yml group' do
      should contain_file('/etc/foreman-proxy/settings.d/abrt.yml').
        with({
          :owner   => 'root',
          :group   => 'example'
        })
    end
  end

  describe 'with faf_ssl_* set' do
    let :pre_condition do
      "include foreman_proxy"
    end
    let :params do {
      :faf_server_ssl_cert => '/faf_cert.pem',
      :faf_server_ssl_key => '/faf_key.pem',
    } end

    it 'should set server_ssl_cert and _key' do
      should contain_file('/etc/foreman-proxy/settings.d/abrt.yml').
        with_content(%r{^:server_ssl_cert:\s+/faf_cert.pem$}).
        with_content(%r{^:server_ssl_key:\s+/faf_key.pem$})
    end
  end
end
