require File.expand_path('../lib/foreman_osc/version', __FILE__)
require 'date'

Gem::Specification.new do |s|
  s.name        = 'foreman_osc'
  s.version     = ForemanOsc::VERSION
  s.date        = Date.today.to_s
  s.licenses    = ["GPL-3"]
  s.authors     = ['Trey Dockendorf']
  s.email       = ['tdockendorf@osc.edu']
  s.homepage    = 'http://osc.edu'
  s.summary     = 'OSC Foreman Plugin'
  # also update locale/gemspec.rb
  s.description = 'OSC Foreman Plugin'

  #s.files = Dir['{app,config,db,lib,locale}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.files = Dir['lib/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'deface'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rdoc'
end
