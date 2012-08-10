require File.dirname(__FILE__) + '/../lib/sickbeard'
require 'fakeweb'

FakeWeb.allow_net_connect = false

RSpec.configure do |config|
  config.order = 'random'

  config.before(:each) do
    FakeWeb.clean_registry
  end
end
