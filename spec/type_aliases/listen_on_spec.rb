require 'spec_helper'

describe 'Foreman_proxy::ListenOn' do
  it { is_expected.to allow_values('http', 'https', 'both') }
  it { is_expected.not_to allow_value(nil) }
  it { is_expected.not_to allow_value('all') }
  it { is_expected.not_to allow_value('htt') }
end
