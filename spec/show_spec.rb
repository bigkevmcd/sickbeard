require 'spec_helper'

describe SickBeard::Show do
  let(:sickbeard) { SickBeard::Client.new(server: 'http://example.com/', api_key: '3095c1a9ac3f9bf4f4d47295904ce631') }
  let(:show) { SickBeard::Show.new(server: sickbeard, tvdbid: 70522) }

  describe "#seasons" do
    it "should get all seasons if no season is supplied" do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=show.seasons&tvdbid=70522&season').
        to_return(:status => 200, :body => load_fixture('show_seasons'))
      result = show.seasons
      result.keys.should == ['0', '1', '2', '3', '4', '5']
    end

    it "should get the specified season if one is provided" do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=show.seasons&tvdbid=70522&season=1').
        to_return(:status => 200, :body => load_fixture('show_seasons_1'))
      result = show.seasons(1)
      result.keys.should == ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22']
    end
  end

  describe "#get_banner" do
    it "should fetch the banner for this show" do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=show.getbanner&tvdbid=70522').
        to_return(:status => 200, :body => "show.get_banner returns a JPEG file directly.\n")
      show.get_banner.should == "show.get_banner returns a JPEG file directly.\n"
    end
  end

  describe "#get_poster" do
    it "should fetch the poster for this show" do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=show.getposter&tvdbid=70522').
        to_return(:status => 200, :body => "show.get_poster returns a JPEG file directly.\n")
      show.get_poster.should == "show.get_poster returns a JPEG file directly.\n"
    end
  end

  describe "#pause" do
    it "should set the show's paused state in SickBeard to be paused" do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=show.pause&tvdbid=70522&pause=1').
        to_return(:status => 200, :body => load_fixture('show_pause'))
      show.pause.should == 'Farscape has been paused'
    end
  end

  describe "#unpause" do
    it "should set the show's paused state in SickBeard to be unpaused" do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=show.pause&tvdbid=70522').
        to_return(:status => 200, :body => load_fixture('show_unpause'))
      show.unpause.should == 'Farscape has been unpaused'
    end
  end

  describe "#paused?" do
    it "should return true if the show is currently paused in SickBeard" do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=show&tvdbid=70522').
        to_return(:status => 200, :body => load_fixture('show_paused'))
      show.should be_paused
    end
    it "should return false if the show is not currently paused in SickBeard" do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=show&tvdbid=70522').
        to_return(:status => 200, :body => load_fixture('show'))
      show.should_not be_paused
    end
  end

  describe "#set_quality" do
    it "should set the quality of a show given a list of initial quality settings" do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?archive=&cmd=show.setquality&tvdbid=70522&initial=sdtv%7Chdtv').
        to_return(:status => 200, :body => load_fixture('show_setquality'))
      show.set_quality(initial: ['sdtv', 'hdtv']).should == 'Farscape quality has been changed to Custom'
    end
    it "should set the quality of a show given a single initial quality setting" do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?archive=&cmd=show.setquality&tvdbid=70522&initial=sdtv').
        to_return(:status => 200, :body => load_fixture('show_setquality'))
      show.set_quality(initial: 'sdtv').should == 'Farscape quality has been changed to Custom'
    end
    it "should set the quality of a show given a list of archive quality settings" do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?archive=sdtv%7Chdtv&cmd=show.setquality&initial=&tvdbid=70522').
        to_return(:status => 200, :body => load_fixture('show_setquality'))
      show.set_quality(archive: ['sdtv', 'hdtv']).should == 'Farscape quality has been changed to Custom'
    end
    it "should set the quality of a show given a single archive quality setting" do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?archive=sdtv&cmd=show.setquality&initial=&tvdbid=70522').
        to_return(:status => 200, :body => load_fixture('show_setquality'))
      show.set_quality(archive: 'sdtv').should == 'Farscape quality has been changed to Custom'
    end
    it "should set the quality of a show given both an initial and archive quality setting" do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=show.setquality&tvdbid=70522&archive=sdtv&initial=hdtv').
        to_return(:status => 200, :body => load_fixture('show_setquality'))
      show.set_quality(archive: 'sdtv', initial: 'hdtv').should == 'Farscape quality has been changed to Custom'
    end
  end
end
