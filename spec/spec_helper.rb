# This file is managed centrally by modulesync
#   https://github.com/theforeman/foreman-installer-modulesync

require 'puppetlabs_spec_helper/module_spec_helper'
require 'lib/module_spec_helper'

require 'rspec-puppet-facts'
include RspecPuppetFacts

require 'rspec-puppet'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

modules_path = [
  File.join(fixture_path, 'modules'),
  #File.expand_path('~/git/puppet/modules'),
  File.expand_path('~/git/theforeman')
]

RSpec.configure do |c|
  c.module_path = modules_path.join(':')
  c.manifest_dir = File.join(fixture_path, 'manifests')
  c.manifest = File.join(fixture_path, 'manifests/site.pp')
end

# Workaround for no method in rspec-puppet to pass undef through :params
class Undef
  def inspect; 'undef'; end
end
