require 'spec_helper'

describe SickBeard do
  let(:sickbeard) { SickBeard::Base.new(server: 'http://example.com/', api_key: '3095c1a9ac3f9bf4f4d47295904ce631') }


  describe "#sb" do
    use_vcr_cassette
    it "should request the SickBeard server information" do
        response = sickbeard.sb
        response['result'].should  == 'success'
    end
  end

  describe "#future" do
    use_vcr_cassette :record => :new_episodes

    it "should return a list of upcoming TV shows" do
      response = sickbeard.future
      response['result'].should  == 'success'
      response['data'].keys.should == ['later', 'missed', 'soon', 'today']
    end

    it "should return a list of upcoming TV shows for today" do
      response = sickbeard.future
      response['result'].should  == 'success'
      response['data']['today'].length.should == 3
      response['data']['today'].collect {|e| e['ep_name']}.should == ['The French Connection Job', 'Gone, Gone, Gone', 'The Price of Greatness']
      response['data']['today'].collect {|e| e['network']}.should == ['TNT', 'HBO', 'TNT']
      response['data']['today'].collect {|e| e['tvdbid']}.should == [82339, 82283, 205281]
    end

    it "should filter the results by type" do
      response = sickbeard.future(:type => ['missed', 'soon'])
      response['result'].should  == 'success'
      response['data'].keys.should == ['missed', 'soon']
    end

    it "should order the results" do
      response = sickbeard.future(:sort => 'network')
      response['result'].should  == 'success'
      response['data']['today'].collect {|e| e['network']}.should == ['HBO', 'TNT', 'TNT']
    end
  end

  describe "#shows_stats" do
    use_vcr_cassette
    it "should return global episode and show statistics" do
      response = sickbeard.shows_stats
      response['result'].should  == 'success'
      response['data']['ep_downloaded'].should == 1653
      response['data']['ep_total'].should == 7595
      response['data']['shows_active'].should == 40
      response['data']['shows_total'].should == 89
    end
  end

  describe "#shows" do
    use_vcr_cassette :record => :new_episodes

    it "should return a list of all known TV shows in SickBeard" do
      response = sickbeard.shows
      response['result'].should  == 'success'
      response['data'].keys[0..4].should == ['70522', '70533', '70726', '71470', '71637']
    end

    it "should order the results" do
      response = sickbeard.shows(:sort => 'name')
      response['result'].should  == 'success'
      response['data'].keys[0..4].should == ["30 Rock", "Accidentally On Purpose", "American Gothic", "American Horror Story", "Andromeda"]
    end
  end
end
