source 'https://rubygems.org'

source ENV['GEM_SOURCE'] || 'https://rubygems.org'

group :development, :test do
  gem 'mime-types', '<2.0',      :require => false
  gem 'rake',  '10.1.1',         :require => false
  gem 'rspec-puppet',            :require => false
  gem 'rspec-puppet-utils',      :require => false
  gem 'puppetlabs_spec_helper', '>= 0.8.2', :require => false
  gem 'serverspec',              :require => false
  gem 'puppet-lint', '>=1.0.0',  :require => false
  gem 'pry',                     :require => false
  gem 'simplecov',               :require => false
  gem 'beaker',                  :require => false
  gem 'beaker-rspec',            :require => false
end

if puppetversion = ENV['PUPPET_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

# vim:ft=ruby
