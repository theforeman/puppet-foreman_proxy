require 'spec_helper'

describe 'foreman_proxy::plugin' do
  let :title do 'myplugin' end

  let :pre_condition do
    'include foreman_proxy'
  end

  let :facts do {
    :concat_basedir         => '/nonexistant',
    :operatingsystem        => 'RedHat',
    :operatingsystemrelease => '6.4',
    :osfamily               => 'RedHat',
  } end

  context 'no parameters' do
    it 'should install the correct package' do
      should contain_package('rubygem-smart_proxy_myplugin').with_ensure('installed')
    end
  end

  context 'with package parameter' do
    let :params do {
      :package => 'myplugin',
    } end

    it 'should install the correct package' do
      should contain_package('myplugin').with_ensure('installed')
    end
  end

  context 'with version parameter' do
    let :params do {
      :version => 'latest',
    } end

    it 'should install the correct package' do
      should contain_package('rubygem-smart_proxy_myplugin').with_ensure('latest')
    end
  end

  context 'when handling underscores on Red Hat' do
    let :params do {
      :package => 'my_fun_plugin',
    } end

    it 'should use underscores' do
      should contain_package('my_fun_plugin').with_ensure('installed')
    end
  end

  context 'when handling underscores on Debian' do
    let :facts do {
      :osfamily => 'Debian',
      :operatingsystemrelease => '8.0',
    } end

    let :params do {
      :package => 'my_fun_plugin',
    } end

    it 'should use hyphens' do
      should contain_package('my-fun-plugin').with_ensure('installed')
    end
  end
end
