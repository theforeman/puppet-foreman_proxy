require 'spec_helper'

describe 'foreman_proxy::feature' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:title) { 'Test' }

      it 'should register feature' do
        is_expected.to contain_datacat_fragment('foreman_proxy::enabled_features::Test').with(
          data: { 'features' => ['Test'] },
          target: 'foreman_proxy::enabled_features',
        )
      end
    end
  end
end
