require 'spec_helper'

describe 'foreman_proxy::tftp::netboot' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let :params do
        {:root => '/tftproot'}
      end

      it { is_expected.to compile.with_all_deps }
    end
  end
end
