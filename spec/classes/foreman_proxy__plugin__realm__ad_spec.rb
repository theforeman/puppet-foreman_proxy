require 'spec_helper'

describe 'foreman_proxy::plugin::realm::ad' do

  let :facts do
    on_supported_os['redhat-7-x86_64']
  end

  describe 'with default settings' do
    let :pre_condition do
      "include foreman_proxy"
    end
    let :params do {
      :realm => 'EXAMPLE.COM',
      :domain_controller => 'dc.example.com'
    } end

    it { should contain_foreman_proxy__plugin('realm_ad_plugin') }
    it 'realm_ad.yml should contain the correct configuration' do
      verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/realm_ad.yml', [
        '---',
        ':domain_controller: dc.example.com',
        ':keytab_path: /etc/foreman-proxy/freeipa.keytab',
        ':principal: realm-proxy@EXAMPLE.COM',
        ':realm: EXAMPLE.COM'
      ])
    end
  end

  describe 'with overwritten parameters' do
    let :pre_condition do
      "class { 'foreman_proxy': realm_principal => 'abc@EXAMPLE.ORG', realm_keytab => '/etc/foreman-proxy/realm_ad.keytab' }"
    end
    let :params do {
      :realm => 'EXAMPLE.ORG',
      :domain_controller => 'dc.example.org',
      :ou => 'OU=Linux,OU=Servers,DC=example,DC=org',
      :computername_prefix => 'ORG-',
      :computername_hash => true,
      :computername_use_fqdn => true
    } end

    it 'realm_ad.yml should contain the correct configuration' do
      verify_exact_contents(catalogue, '/etc/foreman-proxy/settings.d/realm_ad.yml', [
        '---',
        ':domain_controller: dc.example.org',
        ':keytab_path: /etc/foreman-proxy/realm_ad.keytab',
        ':principal: abc@EXAMPLE.ORG',
        ':realm: EXAMPLE.ORG',
        ":ou: 'OU=Linux,OU=Servers,DC=example,DC=org'",
        ":computername_prefix: 'ORG-'",
        ':computername_hash: true',
        ':computername_use_fqdn: true'
      ])
    end
  end

  describe 'with group overridden' do
    let :pre_condition do
      "include foreman_proxy"
    end
    let :params do {
      :group => 'example',
      :realm => 'EXAMPLE.COM',
      :domain_controller => 'dc.example.com'
    } end

    it 'should change realm_ad.yml group' do
      should contain_file('/etc/foreman-proxy/settings.d/realm_ad.yml').
        with({
          :owner   => 'root',
          :group   => 'example'
        })
    end
  end
end
