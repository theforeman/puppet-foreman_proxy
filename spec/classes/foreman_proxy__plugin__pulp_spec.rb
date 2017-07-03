require 'spec_helper'

describe 'foreman_proxy::plugin::pulp' do

  let :puppet_environmentpath do
    # In Puppet 3, Puppet[:environmentpath] default is ""
    Gem::Version.new(Puppet.version) >= Gem::Version.new('4.0') ? '/etc/puppetlabs/code/environments' : ""
  end

  let :facts do
    on_supported_os['redhat-6-x86_64'].merge(:puppet_environmentpath => puppet_environmentpath)
  end

  let(:node) { 'foo.example.com' }

  let :etc_dir do
    '/etc'
  end

  describe 'with default settings' do
    let :pre_condition do
      "include foreman_proxy"
    end

    it { should contain_foreman_proxy__plugin('pulp') }
    it 'should configure pulp.yml' do
      should contain_file('/etc/foreman-proxy/settings.d/pulp.yml').
        with({
          :ensure  => 'file',
          :owner   => 'root',
          :group   => 'foreman-proxy'
        })
        verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/pulp.yml", [
          '---',
          ':enabled: https',
          ":pulp_url: https://#{facts[:fqdn]}/pulp",
          ':pulp_dir: /var/lib/pulp',
          ':pulp_content_dir: /var/lib/pulp/content',
          ":puppet_content_dir: #{puppet_environmentpath.empty? ? '/etc/puppet/environments' : puppet_environmentpath}",
          ':mongodb_dir: /var/lib/mongodb',
        ])
    end
  end

  describe 'with overrides' do
    let :pre_condition do
      "include foreman_proxy"
    end
    let :params do {
      :group => 'example',
      :puppet_content_dir => '/tmp/foo',
    } end

    it 'should change pulp.yml group' do
      should contain_file('/etc/foreman-proxy/settings.d/pulp.yml').
        with({
          :owner   => 'root',
          :group   => 'example'
        })
    end

    it 'should generate correct pulp.yml' do
      verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/pulp.yml", [
        '---',
        ':enabled: https',
        ":pulp_url: https://#{facts[:fqdn]}/pulp",
        ':pulp_dir: /var/lib/pulp',
        ':pulp_content_dir: /var/lib/pulp/content',
        ':puppet_content_dir: /tmp/foo',
        ':mongodb_dir: /var/lib/mongodb',
      ])
    end
  end
end
