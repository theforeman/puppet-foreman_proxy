shared_examples 'the default foreman proxy application' do
  describe service('foreman-proxy') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe port(8000) do
    it { is_expected.not_to be_listening }
  end

  describe port(8443) do
    it { is_expected.to be_listening }
  end
end
