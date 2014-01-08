# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sickbeard/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Kevin McDermott', 'Ryan Lovelett']
  gem.email         = %w{bigkevmcd@gmail.com ryan@lovelett.me}
  gem.summary       = %q{A Ruby interface for the Sick Beard API}
  gem.description   = %q{A Ruby interface for interacting with the Sick Beard PRV API (http://sickbeard.com/api)}
  gem.homepage      = 'https://github.com/RLovelett/sick-beard'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'sickbeard'
  gem.require_paths = %w{lib}
  gem.version       = SickBeard::VERSION

  gem.add_dependency 'json', '~> 1.8.1'
  gem.add_dependency 'rest-client', '~> 1.6.7'

  gem.add_development_dependency 'rake', '~> 10.0.4'
  gem.add_development_dependency 'rspec', '~> 2.13.0'
  gem.add_development_dependency 'rspec-xml', '~> 0.0.6'
  gem.add_development_dependency 'guard-rspec', '~> 2.5.1'
  gem.add_development_dependency 'rb-fsevent', '~> 0.9.1'
  gem.add_development_dependency 'growl', '~> 1.0.3'
  gem.add_development_dependency 'terminal-notifier-guard', '~> 1.5.3'
  gem.add_development_dependency 'vcr', '~> 2.8.0'
  gem.add_development_dependency 'webmock', '~> 1.9.0'
  gem.add_development_dependency 'faker', '~> 1.1.2'
  gem.add_development_dependency 'simplecov', '~> 0.7.1'
  gem.add_development_dependency 'coveralls'
end
