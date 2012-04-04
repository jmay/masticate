# -*- encoding: utf-8 -*-
require File.expand_path('../lib/masticate/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jason May"]
  gem.email         = ["jmay@pobox.com"]
  gem.description   = %q{Data file crunching}
  gem.summary       = %q{Utility functions for parsing incoming text data files.}
  gem.homepage      = ""
  gem.rubyforge_project = "masticate"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "masticate"
  gem.require_paths = ["lib"]
  gem.version       = Masticate::VERSION

  gem.add_development_dependency "rspec", "~> 2.9"
  gem.add_development_dependency "guard-rspec", "~> 0.7"
end
