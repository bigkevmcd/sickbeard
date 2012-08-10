require 'spec_helper'

describe SickBeard do
  let(:sickbeard) { SickBeard::Base.new(server: 'http://example.com/', api_key: '4075c1a7ac4f7bf4f4d47275704ce641') }


  describe "#sb" do
    it "should request the SickBeard server information" do
      FakeWeb.register_uri(:get, 'http://example.com/api/4075c1a7ac4f7bf4f4d47275704ce641/?cmd=sb', body: '{"result": "success"}')
      response = sickbeard.sb
      response['result'].should  == 'success'
    end
  end

  describe "#future" do
    it "should return a list of upcoming TV shows" do
      sickbeard.should_receive(:make_request).with('future').and_return('{"result": "success"}')
      sickbeard.future['result'].should == "success"
    end
  end
end
