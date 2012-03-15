# -*- encoding: utf-8 -*-
require File.expand_path('../lib/with_filters/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'with_filters'
  gem.version     = WithFilters::VERSION

  gem.authors     = ['Aaron Lasseigne']
  gem.email       = ['aaron.lasseigne@gmail.com']
  gem.summary     = %q{Add filtering to lists, tables, etc.}
  gem.description = %q{Add filtering to lists, tables, etc.}
  gem.homepage    = 'https://github.com/AaronLasseigne/with_filters'

  gem.rubyforge_project = 'with_filters'

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ['lib']

  gem.add_dependency 'rails', '>= 3.1'

  gem.add_development_dependency 'rspec-rails'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'genspec'
  gem.add_development_dependency 'capybara'
end
