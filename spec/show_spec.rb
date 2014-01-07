require 'spec_helper'

describe SickBeard::Show, vcr: {
  cassette_name: 'sickbeard',
  record: :new_episodes,
  match_requests_on: [:uri]
} do
  let(:sickbeard) { SickBeard::Client.new(server: api_uri, api_key: api_key) }
  let(:show) { SickBeard::Show.new(server: sickbeard, tvdbid: 70522) }

  describe "#seasons" do
    it "should get all seasons if no season is supplied" do
      result = show.seasons
      result.keys.should == ['0', '1', '2', '3', '4', '5']
    end

    it "should get the specified season if one is provided" do
      result = show.seasons(1)
      result.keys.should == ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22']
    end
  end

  describe "#get_banner" do
    it "should fetch the banner for this show" do
      show.get_banner.should == "show.get_banner returns a JPEG file directly.\n"
    end
  end

  describe "#get_poster" do
    it "should fetch the poster for this show" do
      show.get_poster.should == "show.get_poster returns a JPEG file directly.\n"
    end
  end

  describe "#pause" do
    it "should set the show's paused state in SickBeard to be paused" do
      show.pause.should == 'Farscape has been paused'
    end
  end

  describe "#unpause" do
    it "should set the show's paused state in SickBeard to be unpaused" do
      show.unpause.should == 'Farscape has been unpaused'
    end
  end

  describe "#paused?" do
    it "should return false if the show is not currently paused in SickBeard" do
      show.should_not be_paused
    end
  end

  describe "#set_quality" do
    it "should set the quality of a show given a list of initial quality settings" do
      show.set_quality(initial: ['sdtv', 'hdtv']).should == 'Farscape quality has been changed to Custom'
    end
    it "should set the quality of a show given a single initial quality setting" do
      show.set_quality(initial: 'sdtv').should == 'Farscape quality has been changed to Custom'
    end
    it "should set the quality of a show given a list of archive quality settings" do
      show.set_quality(archive: ['sdtv', 'hdtv']).should == 'Farscape quality has been changed to Custom'
    end
    it "should set the quality of a show given a single archive quality setting" do
      show.set_quality(archive: 'sdtv').should == 'Farscape quality has been changed to Custom'
    end
    it "should set the quality of a show given both an initial and archive quality setting" do
      show.set_quality(archive: 'sdtv', initial: 'hdtv').should == 'Farscape quality has been changed to Custom'
    end
  end

  describe "#season_list" do
    it "should return the season list if it was already populated" do
      new_show = SickBeard::Show.new(server: sickbeard, tvdbid: 70522, season_list: [3, 2, 1, 0])
      new_show.season_list.should == [0, 1, 2, 3]
    end
    it "should fetch the season list if it is unknown" do
      new_show = SickBeard::Show.new(server: sickbeard, tvdbid: 70522)
      new_show.season_list.should == [0, 1, 2, 3, 4, 5]
    end
  end

  describe "#show_stats" do
    it "should get the stats for the show" do
      response = show.stats
      response['total'].should == 92
    end
  end

  describe "#cached_banner?" do
    it "should return true if the banner image cache is valid for this show" do
      show.should have_cached_banner
    end
  end

  describe "#cached_poster?" do
    it "should return true if the banner image cache is valid for this show" do
      show.should have_cached_poster
    end
  end

  describe "#update" do
    it "should update a show in SickBeard by pulling down information from TVDB and rescan local files." do
      show.update.should == 'Farscape has queued to be updated'
    end
  end

  describe "#refresh" do
    it "should refresh a show in SickBeard by pulling down information from TVDB and rescan local files." do
      show.refresh.should == 'Farscape has queued to be refreshed'
    end
  end

  describe "#addnew" do
    it "should add a show to SickBeard." do
      show.addnew.should == 'Farscape has been queued to be added'
    end
    it "should pass the season_folder option if provided." do
      show.addnew(season_folder: 1).should == 'Farscape has been queued to be added'
    end
    it "should pass the location option if provided." do
      show.addnew(location: '/storage/videos/').should == 'Farscape has been queued to be added'
    end
    it "should pass the status option if provided" do
      show.addnew(status: 'wanted').should == 'Farscape has been queued to be added'
    end
    it "should pass the lang option if provided" do
      show.addnew(lang: 'nl').should == 'Farscape has been queued to be added'
    end
    it "should correctly pass initial options if provided." do
      show.addnew(initial: ['sdtv','hdtv']).should == 'Farscape has been queued to be added'
    end
    it "should correctly pass archive options if provided." do
      show.addnew(archive: ['sdtv','hdtv']).should == 'Farscape has been queued to be added'
    end
  end

  describe "#delete" do
    it "should remove a show from SickBeard." do
      show.delete.should == 'Farscape has been deleted'
    end
  end
end
