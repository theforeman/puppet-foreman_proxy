require 'spec_helper'

describe 'foreman_proxy::plugin::pulp' do
  let :facts do
    on_supported_os['redhat-7-x86_64']
  end

  let :pre_condition do
    'include foreman_proxy'
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

      verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/pulp.yml", [
                              '---',
                              ':enabled: https',
                              ":pulp_url: https://#{facts[:fqdn]}/pulp",
                              ':pulp_dir: /var/lib/pulp',
                              ':pulp_content_dir: /var/lib/pulp/content',
                              ':puppet_content_dir: /etc/puppetlabs/code/environments',
                              ':mongodb_dir: /var/lib/mongodb'
                            ])
    end

    it 'should configure pulpnode.yml' do
      is_expected.to contain_file("#{etc_dir}/foreman-proxy/settings.d/pulpnode.yml")
        .with_ensure('file')
        .with_owner('root')
        .with_group('foreman-proxy')

      verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/pulpnode.yml", [
                              '---',
                              ':enabled: false',
                              ":pulp_url: https://#{facts[:fqdn]}/pulp",
                              ':pulp_dir: /var/lib/pulp',
                              ':pulp_content_dir: /var/lib/pulp/content',
                              ':puppet_content_dir: /etc/puppetlabs/code/environments',
                              ':mongodb_dir: /var/lib/mongodb'
                            ])
    end

    it 'should configure pulp3.yml' do
      is_expected.to contain_file("#{etc_dir}/foreman-proxy/settings.d/pulp3.yml")
        .with_ensure('file')
        .with_owner('root')
        .with_group('foreman-proxy')

      verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/pulp3.yml", [
                              '---',
                              ':enabled: false',
                              ":pulp_url: https://#{facts[:fqdn]}/pulp",
                              ':pulp_dir: /var/lib/pulp',
                              ':pulp_content_dir: /var/lib/pulp/content',
                              ':puppet_content_dir: /etc/puppetlabs/code/environments',
                              ':mirror: false'
                            ])
    end
  end

  describe 'with overrides' do
    let :params do
      {
        group: 'example',
        pulpnode_enabled: true,
        pulp3_enabled: true,
        pulp3_mirror: true,
        pulp_url: 'https://pulp.example.com',
        pulp_dir: '/tmp/pulp',
        pulp_content_dir: '/tmp/content',
        puppet_content_dir: '/tmp/puppet',
        mongodb_dir: '/tmp/mongodb',
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_foreman_proxy__plugin('pulp') }

    it 'should configure pulp.yml' do
      is_expected.to contain_file("#{etc_dir}/foreman-proxy/settings.d/pulp.yml")
        .with_owner('root')
        .with_group('example')

      verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/pulp.yml", [
                              '---',
                              ':enabled: https',
                              ':pulp_url: https://pulp.example.com',
                              ':pulp_dir: /tmp/pulp',
                              ':pulp_content_dir: /tmp/content',
                              ':puppet_content_dir: /tmp/puppet',
                              ':mongodb_dir: /tmp/mongodb'
                            ])
    end

    it 'should configure pulpnode.yml' do
      is_expected.to contain_file("#{etc_dir}/foreman-proxy/settings.d/pulpnode.yml")
        .with_ensure('file')
        .with_owner('root')
        .with_group('example')

      verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/pulpnode.yml", [
                              '---',
                              ':enabled: https',
                              ':pulp_url: https://pulp.example.com',
                              ':pulp_dir: /tmp/pulp',
                              ':pulp_content_dir: /tmp/content',
                              ':puppet_content_dir: /tmp/puppet',
                              ':mongodb_dir: /tmp/mongodb'
                            ])
    end

    it 'should configure pulp3.yml' do
      is_expected.to contain_file("#{etc_dir}/foreman-proxy/settings.d/pulp3.yml")
        .with_ensure('file')
        .with_owner('root')
        .with_group('example')

      verify_exact_contents(catalogue, "#{etc_dir}/foreman-proxy/settings.d/pulp3.yml", [
                              '---',
                              ':enabled: https',
                              ':pulp_url: https://pulp.example.com',
                              ':pulp_dir: /tmp/pulp',
                              ':pulp_content_dir: /tmp/content',
                              ':puppet_content_dir: /tmp/puppet',
                              ':mirror: true'
                            ])
    end
  end
end
