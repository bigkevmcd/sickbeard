require 'spec_helper'

describe SickBeard::Client, vcr: {
  cassette_name: 'sickbeard',
  record: :new_episodes,
  match_requests_on: [:uri]
} do
  let(:sickbeard) { SickBeard::Client.new(server: api_uri, api_key: api_key ) }

  describe "#make_json_request" do
    it "should raise an exception if the result is not success" do
        expect { sickbeard.make_json_request('testing') }.to raise_error(SickBeard::Error)
    end
  end

  describe "#make_request" do
    it "should make a request and return the body of the response" do
        sickbeard.make_request('testing').should == '{"result":"failure"}'
    end
  end

  describe "#sb" do
    it "should request the SickBeard server information" do
        response = sickbeard.sb
    end
  end

  describe "#future" do
    it "should return a list of upcoming TV shows" do
      response = sickbeard.future
      response.keys.should == ['later', 'missed', 'soon', 'today']
    end

    it "should return a list of upcoming TV shows for today" do
      response = sickbeard.future
      response['today'].length.should == 3
      response['today'].collect {|e| e['show_name']}.should == ['Leverage', 'True Blood', 'Falling Skies']
      response['today'].collect {|e| e['ep_name']}.should == ['The French Connection Job', 'Gone, Gone, Gone', 'The Price of Greatness']
      response['today'].collect {|e| e['network']}.should == ['TNT', 'HBO', 'TNT']
      response['today'].collect {|e| e['tvdbid']}.should == [82339, 82283, 205281]
    end

    it "should filter the results by type" do
      response = sickbeard.future(:type => ['missed', 'soon'])
      response.keys.should == ['missed', 'soon']
    end

    it "should order the results" do
      response = sickbeard.future(:sort => 'network')
      response['today'].collect {|e| e['network']}.should == ['HBO', 'TNT', 'TNT']
    end
  end

  describe "#shows_stats" do
    it "should return global episode and show statistics" do
      response = sickbeard.shows_stats
      response['ep_downloaded'].should == 1653
      response['ep_total'].should == 7595
      response['shows_active'].should == 40
      response['shows_total'].should == 89
    end
  end

  describe "#shows" do
    it "should return a list of all known TV shows in SickBeard" do
      response = sickbeard.shows

      response.length.should == 89
      response[0..4].collect { |show| show.name }.should == [
        'Farscape',  'Twin Peaks', 'Babylon 5',
        'Star Trek: The Next Generation', 'The Wild Wild West']
    end

    it "should order the results" do
      response = sickbeard.shows(sort: 'name')

      response.length.should == 89
      response[0..4].collect { |show| show.name }.should == [
        '30 Rock', 'Accidentally On Purpose', 'American Gothic',
        'American Horror Story', 'Andromeda']
    end
  end

  describe "#show" do
    it "should get the information for a given show" do
      show = sickbeard.show(70522)
      show.should be_an_instance_of SickBeard::Show
      show.name.should == 'Farscape'
      show.genres.should == ['Science-Fiction']
      show.status.should == 'Ended'
      show.season_list.should == [0, 1, 2, 3, 4, 5]
      show.tvdbid.should == 70522
      show.server.should == sickbeard
      show.quality.should == "SD"
    end
  end

  describe "#searchtvdb" do
    it "should search the tv db by name" do
      result = sickbeard.searchtvdb('Star')
      result.length.should == 94
      result[0].should be_an_instance_of SickBeard::Show
      result[0].name.should == 'Fist of the North Star'
    end
  end
end
