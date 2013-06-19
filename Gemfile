source "https://rubygems.org"

gem 'rake'

puppetversion = ENV.key?('PUPPET_VERSION') ? "~> #{ENV['PUPPET_VERSION']}" : ['>= 2.6']
gem 'puppet', puppetversion

gem 'puppetlabs_spec_helper'
gem 'puppet-lint'
