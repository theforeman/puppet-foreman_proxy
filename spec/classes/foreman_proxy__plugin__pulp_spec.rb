require 'spec_helper'

describe 'foreman_proxy::plugin::pulp' do

  let :facts do
    on_supported_os['redhat-6-x86_64']
  end

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
        ':mongodb_dir: /var/lib/mongodb',
      ])
    end
  end
end
