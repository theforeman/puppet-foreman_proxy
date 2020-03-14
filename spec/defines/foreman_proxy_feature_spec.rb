require 'spec_helper'

describe 'foreman_proxy::feature' do
  let(:title) { 'Test' }

  it { is_expected.to compile.with_all_deps }
  it 'should register feature' do
    is_expected.to contain_datacat_fragment('foreman_proxy::enabled_features::Test').with(
      data: { 'features' => ['Test'] },
      target: 'foreman_proxy::enabled_features',
    )
  end
end
