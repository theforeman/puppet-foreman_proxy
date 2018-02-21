require 'spec_helper'

describe 'foreman_proxy::plugin::pulp' do
  let :facts do
    on_supported_os['redhat-7-x86_64']
  end

  let :pre_condition do
    "include foreman_proxy"
  end

  let :etc_dir do
    '/etc'
  end

  describe 'with default settings' do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_foreman_proxy__plugin('pulp') }

    it 'should configure pulp.yml' do
      is_expected.to contain_file("#{etc_dir}/foreman-proxy/settings.d/pulp.yml")
        .with_ensure('file')
        .with_owner('root')
        .with_group('foreman-proxy')
    end

    it 'should generate correct pulp.yml' do
      verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/pulp.yml", [
        '---',
        ':enabled: https',
        ":pulp_url: https://#{facts[:fqdn]}/pulp",
        ':pulp_dir: /var/lib/pulp',
        ':pulp_content_dir: /var/lib/pulp/content',
        ':puppet_content_dir: /etc/puppetlabs/code/environments',
        ':mongodb_dir: /var/lib/mongodb',
      ])
    end
  end

  describe 'with overrides' do
    let :params do {
      :group => 'example',
      :puppet_content_dir => '/tmp/foo',
    } end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_foreman_proxy__plugin('pulp') }

    it 'should change pulp.yml group' do
      is_expected.to contain_file("#{etc_dir}/foreman-proxy/settings.d/pulp.yml")
        .with_owner('root')
        .with_group('example')
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
