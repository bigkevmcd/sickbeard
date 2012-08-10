# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sickbeard/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Kevin McDermott"]
  gem.email         = ["bigkevmcd@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "sickbeard"
  gem.require_paths = ["lib"]
  gem.version       = SickBeard::VERSION

  gem.add_dependency("json", ">= 1.7.4")

  gem.add_development_dependency("rspec", ">= 2.11.0")
  gem.add_development_dependency("fakeweb", ">= 1.3.0")
end
