source "https://rubygems.org"

rakeversion = RUBY_VERSION =~ /^1.8/ ? "<10.2.0" : ">= 0"
gem 'rake', rakeversion

puppetversion = ENV.key?('PUPPET_VERSION') ? "~> #{ENV['PUPPET_VERSION']}" : ['>= 2.6']
gem 'puppet', puppetversion

gem 'puppetlabs_spec_helper'
gem 'puppet-lint'
