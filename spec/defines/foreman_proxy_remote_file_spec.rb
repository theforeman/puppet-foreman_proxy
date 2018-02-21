require 'spec_helper'

describe 'foreman_proxy::remote_file' do
  let(:title) { '/tmp/a' }

  let(:params) do
    {
      remote_location: 'https://example.com/tmp/a',
      mode: '0664'
    }
  end

  context 'default scenario' do
    it { is_expected.to contain_exec('mkdir -p /tmp') }

    it do
      is_expected.to contain_file('/tmp/a')
        .with_source('https://example.com/tmp/a')
        .with_mode('0664')
        .that_requires('Exec[mkdir -p /tmp]')
    end
  end

  context 'with parent file defined' do
    let :pre_condition do
      "file { '/tmp': }"
    end

    it { is_expected.to contain_exec('mkdir -p /tmp').that_requires('File[/tmp]') }
  end
end
