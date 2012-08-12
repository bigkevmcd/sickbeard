#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rake/testtask"
require "rdoc/task"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "sickbeard #{SickBeard::VERSION}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :default  => :spec
