module SickBeard

  class Show
    attr_reader :name, :genres, :status, :season_list, :server, :tvdbid, :quality
    def self.from_response(server, tvdbid, response)
      options = {
        name: response['show_name'],
        genres: response['genre'],
        status: response['status'],
        season_list: response['season_list'].sort,
        quality: response['quality'],
        server: server,
        tvdbid: tvdbid
      }
      Show.new(options)
    end

    def initialize(options = {})

      options = { name: '',
                  genres: '',
                  status: '',
                  season_list: '',
                  }.merge(options)
      @name = options[:name]
      @genres = options[:genres]
      @status = options[:status]
      @season_list = options[:season_list]
      @server = options[:server]
      @tvdbid = options[:tvdbid]
      @quality = options[:quality]
    end

    def seasons(season = nil)
      @server.make_json_request('show.seasons', tvdbid: @tvdbid, season: season)['data']
    end

    def get_banner
      @server.make_request('show.getbanner', tvdbid: @tvdbid)
    end

    def get_poster
      @server.make_request('show.getposter', tvdbid: @tvdbid)
    end

    def pause
      @server.make_json_request('show.pause', tvdbid: @tvdbid, pause: 1)['message']
    end

    def unpause
      @server.make_json_request('show.pause', tvdbid: @tvdbid)['message']
    end

    def paused?
      @server.make_json_request('show', tvdbid: @tvdbid)['data']['paused'] == 1
    end

    def set_quality(options)
      initial = [*(options[:initial] || [])].join('|')
      archive = [*(options[:archive] || [])].join('|')
      @server.make_json_request('show.setquality', tvdbid: @tvdbid, initial: initial, archive: archive)['message']
    end
  end
end
