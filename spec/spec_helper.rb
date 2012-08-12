require File.dirname(__FILE__) + '/../lib/sickbeard'
require 'webmock/rspec'
require 'vcr'

RSpec.configure do |config|
  config.order = 'random'
  config.extend VCR::RSpec::Macros
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
end
