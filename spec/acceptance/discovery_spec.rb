require 'spec_helper_acceptance'
require 'json'

shared_examples 'the discovery feature is enabled' do
  describe command('curl -sk https://127.0.0.1:8443/features') do
    it { expect(JSON.parse(subject.stdout)).to include('discovery', 'logs') }
    its(:exit_status) { is_expected.to eq (0) }
  end
end

describe 'Scenario: install foreman-proxy with discovery plugin'  do
  before(:context) { purge_foreman_proxy }

  context 'without params' do
    include_examples 'the example', 'discovery.pp'

    it_behaves_like 'the default foreman proxy application'
    it_behaves_like 'the discovery feature is enabled'
  end

  context 'with install_images param' do
    include_examples 'the example', 'discovery_images.pp'

    it_behaves_like 'the default foreman proxy application'
    it_behaves_like 'the discovery feature is enabled'

    %w[
      /boot/fdi-image-latest.tar
      /boot/fdi-image/initrd0.img
      /boot/fdi-image/vmlinuz0
    ].each do |f|
      describe file(File.join(tftp_root, f)) do
        it { is_expected.to be_file }
        it { is_expected.to be_owned_by 'foreman-proxy' }
        it { is_expected.to be_grouped_into 'foreman-proxy' }
        it { is_expected.to be_mode '644' }
      end
    end

    describe file(File.join(tftp_root, '/boot/fdi-image')) do
      it { is_expected.to be_directory }
      it { is_expected.to be_owned_by 'foreman-proxy' }
      it { is_expected.to be_grouped_into 'foreman-proxy' }
      it { is_expected.to be_mode '755' }
    end
  end
end
