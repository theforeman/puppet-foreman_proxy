require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'test::listen_on', type: :class do
    describe 'valid handling' do
      %w{
        http
        https
        both
      }.each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile }
        end
      end
    end

    describe 'invalid value handling' do
      context 'garbage inputs' do
        [
          nil,
          "all",
          "htt",
        ].each do |value|
          describe value.inspect do
            let(:params) {{ value: value }}
            it { is_expected.to compile.and_raise_error(/parameter 'value' expects a match for Foreman_proxy::ListenOn/) }
          end
        end
      end

    end
  end
end
