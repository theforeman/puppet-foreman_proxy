require 'spec_helper'

shared_examples 'remote_file' do
  it { is_expected.to contain_exec('mkdir -p /tmp') }
end

describe 'foreman_proxy::remote_file' do
  let(:title) { '/tmp/a' }

  context 'without owner/group params' do
    let(:params) do
      {
        remote_location: 'https://example.com/tmp/a',
        mode: '0664'
      }
    end

    context 'default scenario' do
      include_examples 'remote_file'

      it do
        is_expected.to contain_file('/tmp/a').with(
          source: 'https://example.com/tmp/a',
          mode: '0664',
          owner: nil,
          group: nil,
        ).without(
        ).that_requires('Exec[mkdir -p /tmp]')
      end
    end

    context 'with parent file defined' do
      let :pre_condition do
        "file { '/tmp': }"
      end

      include_examples 'remote_file'

      it { is_expected.to contain_exec('mkdir -p /tmp').that_requires('File[/tmp]') }
    end
  end

  context 'with owner/group params' do
    let(:params) do
      {
        remote_location: 'https://example.com/tmp/a',
        mode: '0664',
        owner: 'foo',
        group: 'bar',
      }
    end

    include_examples 'remote_file'

    it do
      is_expected.to contain_file('/tmp/a').with(
        source: 'https://example.com/tmp/a',
        mode: '0664',
        owner: 'foo',
        group: 'bar',
      ).that_requires('Exec[mkdir -p /tmp]')
    end
  end
end
