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

  describe "#season_list" do
    it "should return the season list if it was already populated" do
      new_show = SickBeard::Show.new(server: sickbeard, tvdbid: 70522, season_list: [3, 2, 1, 0])
      new_show.season_list.should == [0, 1, 2, 3]
    end
    it "should fetch the season list if it is unknown" do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=show.seasonlist&tvdbid=70522').
        to_return(:status => 200, :body => load_fixture('show_seasonlist'))
      new_show = SickBeard::Show.new(server: sickbeard, tvdbid: 70522)
      new_show.season_list.should == [0, 1, 2, 3, 4, 5]
    end
  end

  describe "#show_stats" do
    it "should get the stats for the show" do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=show.stats&tvdbid=70522').
        to_return(:status => 200, :body => load_fixture('show_stats'))

      response = show.stats
      response['total'].should == 92
    end
  end

  describe "#cached_banner?" do
    it "should return true if the banner image cache is valid for this show" do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=show.cache&tvdbid=70522').
        to_return(:status => 200, :body => load_fixture('cache_valid'))
      show.should have_cached_banner
    end
    it "should return false if the banner image cache is not valid for this show" do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=show.cache&tvdbid=70522').
        to_return(:status => 200, :body => load_fixture('cache_invalid'))
      show.should_not have_cached_banner
    end
  end

  describe "#cached_poster?" do
    it "should return true if the banner image cache is valid for this show" do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=show.cache&tvdbid=70522').
        to_return(:status => 200, :body => load_fixture('cache_valid'))
      show.should have_cached_poster
    end
    it "should return false if the banner image cache is not valid for this show" do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=show.cache&tvdbid=70522').
        to_return(:status => 200, :body => load_fixture('cache_invalid'))
      show.should_not have_cached_poster
    end
  end

  describe "#update" do
    it "should update a show in SickBeard by pulling down information from TVDB and rescan local files." do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=show.update&tvdbid=70522').
        to_return(:status => 200, :body => load_fixture('show_update'))
      show.update.should == 'Farscape has queued to be updated'
    end
  end

  describe "#refresh" do
    it "should refresh a show in SickBeard by pulling down information from TVDB and rescan local files." do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=show.refresh&tvdbid=70522').
        to_return(:status => 200, :body => load_fixture('show_refresh'))
      show.refresh.should == 'Farscape has queued to be refreshed'
    end
  end

  describe "#addnew" do
    it "should add a show to SickBeard." do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=show.addnew&tvdbid=70522').
        to_return(:status => 200, :body => load_fixture('show_addnew'))
      show.addnew.should == 'Farscape has been queued to be added'
    end
    it "should pass the season_folder option if provided." do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=show.addnew&season_folder=1&tvdbid=70522').
        to_return(:status => 200, :body => load_fixture('show_addnew'))
      show.addnew(season_folder: 1).should == 'Farscape has been queued to be added'
    end
    it "should pass the location option if provided." do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=show.addnew&location=/storage/videos/&tvdbid=70522').
        to_return(:status => 200, :body => load_fixture('show_addnew'))
      show.addnew(location: '/storage/videos/').should == 'Farscape has been queued to be added'
    end
    it "should pass the status option if provided" do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=show.addnew&status=wanted&tvdbid=70522').
        to_return(:status => 200, :body => load_fixture('show_addnew'))
      show.addnew(status: 'wanted').should == 'Farscape has been queued to be added'
    end
    it "should pass the lang option if provided" do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=show.addnew&lang=nl&tvdbid=70522').
        to_return(:status => 200, :body => load_fixture('show_addnew'))
      show.addnew(lang: 'nl').should == 'Farscape has been queued to be added'
    end
    it "should correctly pass initial options if provided." do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=show.addnew&initial=sdtv%7Chdtv&tvdbid=70522').
        to_return(:status => 200, :body => load_fixture('show_addnew'))
      show.addnew(initial: ['sdtv','hdtv']).should == 'Farscape has been queued to be added'
    end
    it "should correctly pass archive options if provided." do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=show.addnew&archive=sdtv%7Chdtv&tvdbid=70522').
        to_return(:status => 200, :body => load_fixture('show_addnew'))
      show.addnew(archive: ['sdtv','hdtv']).should == 'Farscape has been queued to be added'
    end
  end

  describe "#delete" do
    it "should remove a show from SickBeard." do
      stub_request(:get, 'http://example.com/api/3095c1a9ac3f9bf4f4d47295904ce631/?cmd=show.delete&tvdbid=70522').
        to_return(:status => 200, :body => load_fixture('show_delete'))
      show.delete.should == 'Farscape has been deleted'
    end
  end
end
