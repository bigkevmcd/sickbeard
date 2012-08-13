require 'spec_helper'

describe SickBeard do
  let(:sickbeard) { SickBeard::Base.new(server: 'http://example.com/', api_key: '3095c1a9ac3f9bf4f4d47295904ce631') }

  describe "#sb" do
    it "should request the SickBeard server information" do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=sb').
        to_return(:status => 200, :body => load_fixture('sb'))
        response = sickbeard.sb
        response['result'].should  == 'success'
    end
  end

  describe "#future" do

    it "should return a list of upcoming TV shows" do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=future&sort&type=').
        to_return(:status => 200, :body => load_fixture('future_1'))
      response = sickbeard.future
      response['result'].should  == 'success'
      response['data'].keys.should == ['later', 'missed', 'soon', 'today']
    end

    it "should return a list of upcoming TV shows for today" do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=future&sort&type=').
        to_return(:status => 200, :body => load_fixture('future_1'))
      response = sickbeard.future
      response['data']['today'].length.should == 3
      response['data']['today'].collect {|e| e['show_name']}.should == ['Leverage', 'True Blood', 'Falling Skies']
      response['data']['today'].collect {|e| e['ep_name']}.should == ['The French Connection Job', 'Gone, Gone, Gone', 'The Price of Greatness']
      response['data']['today'].collect {|e| e['network']}.should == ['TNT', 'HBO', 'TNT']
      response['data']['today'].collect {|e| e['tvdbid']}.should == [82339, 82283, 205281]
    end

    it "should filter the results by type" do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=future&sort&type=missed%7Csoon').
        to_return(:status => 200, :body => load_fixture('future_2'))
      response = sickbeard.future(:type => ['missed', 'soon'])
      response['result'].should  == 'success'
      response['data'].keys.should == ['missed', 'soon']
    end

    it "should order the results" do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=future&sort=network&type=').
        to_return(:status => 200, :body => load_fixture('future_3'))
      response = sickbeard.future(:sort => 'network')
      response['result'].should  == 'success'
      response['data']['today'].collect {|e| e['network']}.should == ['HBO', 'TNT', 'TNT']
    end
  end

  describe "#shows_stats" do
    it "should return global episode and show statistics" do
       stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=shows.stats').
         to_return(:status => 200, :body => load_fixture('shows_stats'))

      response = sickbeard.shows_stats
      response['result'].should  == 'success'
      response['data']['ep_downloaded'].should == 1653
      response['data']['ep_total'].should == 7595
      response['data']['shows_active'].should == 40
      response['data']['shows_total'].should == 89
    end
  end

  describe "#shows" do

    it "should return a list of all known TV shows in SickBeard" do
       stub_request(:get, "http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=shows&sort").
         to_return(:status => 200, :body => load_fixture('shows_1'))
      response = sickbeard.shows
      response['result'].should  == 'success'
      response['data'].keys[0..4].should == ['70522', '70533', '70726', '71470', '71637']
    end

    it "should order the results" do
       stub_request(:get, "http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=shows&sort=name").
         to_return(:status => 200, :body => load_fixture('shows_2'))
      response = sickbeard.shows(:sort => 'name')
      response['result'].should  == 'success'
      response['data'].keys[0..4].should == ["30 Rock", "Accidentally On Purpose", "American Gothic", "American Horror Story", "Andromeda"]
    end
  end

  describe "#show_stats" do
    it "should get the stats for a show by tvdbid" do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=show.stats&tvdbid=70522').
        to_return(:status => 200, :body => load_fixture('show_stats'))

      response = sickbeard.show_stats(70522)
      response['result'].should == 'success'
      response['data']['total'].should == 92
    end
  end

  describe "#show" do
    it "should get the information for a given show" do
        stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=show&tvdbid=70522').
          to_return(:status => 200, :body => load_fixture('show'))
        response = sickbeard.show(70522)
        response['result'].should == 'success'
        response['data']['show_name'] == 'Farscape'
    end
  end
end
