require File.dirname(__FILE__) + '/../lib/sickbeard'
require 'webmock/rspec'
require 'json'


RSpec.configure do |config|
  config.order = 'random'
end

def load_fixture(fixture_name)
    File.open(File.dirname(__FILE__) + "/fixtures/#{fixture_name}.json")
end
