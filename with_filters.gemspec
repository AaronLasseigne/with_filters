# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'with_filters/version'

Gem::Specification.new do |gem|
  gem.name        = 'with_filters'
  gem.version     = WithFilters::VERSION
  gem.summary     = %q{Add filtering to lists, tables, etc.}
  gem.description = gem.summary
  gem.homepage    = 'https://github.com/AaronLasseigne/with_filters'

  gem.authors     = ['Aaron Lasseigne']
  gem.email       = ['aaron.lasseigne@gmail.com']

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'rails', '>= 3.1'

  gem.add_development_dependency 'rspec-rails'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'genspec'
  gem.add_development_dependency 'capybara'
end
