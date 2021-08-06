def on_plugin_os
  supported_os = [
    {
      'operatingsystem' => 'RedHat',
      'operatingsystemrelease' => ['7'],
    },
    {
      'operatingsystem' => 'Debian',
      'operatingsystemrelease' => ['10'],
    },
  ]
  on_supported_os(supported_os: supported_os)
end

def describe_plugin(name, &block)
  supported_os = [
    {
      'operatingsystem' => 'RedHat',
      'operatingsystemrelease' => ['7'],
    },
    {
      'operatingsystem' => 'Debian',
      'operatingsystemrelease' => ['10'],
    },
  ]

  describe name do
    on_supported_os(supported_os: supported_os).each do |os, os_facts|
      context("on #{os}") do
        let(:facts) { os_facts }
        let(:pre_condition) { 'include foreman_proxy' }

        class_exec(&block)
      end
    end
  end
end

shared_examples 'a plugin with a settings file' do |plugin|
  let(:expected_enabled) { true }
  let(:expected_lisen_on) { 'https' }

  it { is_expected.to compile.with_all_deps }

  it 'contains the plugin' do
    is_expected.to contain_foreman_proxy__plugin__module(plugin)
      .with_enabled(expected_enabled)
      .with_listen_on('https')
  end

  it 'includes a configuration file' do
    is_expected.to contain_foreman_proxy__settings_file(plugin)
    is_expected.to contain_file("/etc/foreman-proxy/settings.d/#{plugin}.yml")
      .with_ensure('file')
      .with_owner('root')
      .with_group('foreman-proxy')
      .with_mode('0640')
      .with_content(expected_config)
  end
end
