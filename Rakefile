#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rake/testtask"
require "rspec/core/rake_task"


RSpec::Core::RakeTask.new(:spec)

Rake::TestTask.new do |t|
            t.libs << "test"
                t.test_files = FileList['test/test*.rb']
                    t.verbose = true
end

task :default  => :spec
