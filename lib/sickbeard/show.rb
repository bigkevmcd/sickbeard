module SickBeard

  class Show
    # @!attribute [r] name
    #   @return [String] the name of the Show
    # @!attribute [r] genres
    #   @return [Array(String)] genres for this Show
    # @!attribute [r] status
    #   @return [String] the status for this Show
    #     * Continuing
    #     * Ended
    # @!attribute [r] season_list
    #  @return [Array(String)] list of known Series for this Show
    # @!attribute [r] server
    #  @return [SickBeard::Client] the server this Show was loaded from
    # @!attribute [r] tvdbid
    #  @return [Integer] the tvdbid for this Show
    # @!attribute [r] quality
    #  @return [String] The download quality for this Show e.g. SD
    attr_reader :name, :genres, :status, :server, :tvdbid, :quality

    def self.from_response(server, tvdbid, response)
      options = {
        name: response['show_name'] || response['name'],
        genres: response['genre'],
        status: response['status'],
        season_list: response['season_list'],
        quality: response['quality'],
        server: server,
        tvdbid: tvdbid
      }
      Show.new(options)
    end

    # Create a new Show
    # @option options [String] :name ("") The name for this show
    # @option options [Array(String)] :genres ("") array of genres applicable to this show.
    # @return [Object] the object.
    def initialize(options = {})

      options = { name: '',
                  genres: '',
                  status: '',
                  season_list: [],
                  }.merge(options)
      @name = options[:name]
      @genres = options[:genres]
      @status = options[:status]
      @season_list = (options[:season_list] || []).sort
      @server = options[:server]
      @tvdbid = options[:tvdbid]
      @quality = options[:quality]
    end

    # Add this show to SickBeard to be tracked.
    # @param [Hash] Options to be passed (location, lang, season_folder, status, initial, archive)
    def track(options = {})

      options[:initial] = [*(options[:initial] || [])].join('|')
      options[:archive] = [*(options[:archive] || [])].join('|')
      
      options = { tvdbid: @tvdbid }.merge(options)

      @server.make_json_request('show.addnew', options)['message']
    end

    # Remove this show from SickBeard.
    def untrack
      @server.make_json_request('show.delete', tvdbid: @tvdbid)['message']
    end

    # Retrieve a listing of episodes for all or a given season.
    # @param [Integer] season optional if provided, fetch only episodes for
    #  the provided season otherwise pulls details down for every season of the how.
    # @return [Array(Hash)]  of season details
    def seasons(season = nil)
      @server.make_json_request('show.seasons', tvdbid: @tvdbid, season: season)['data']
    end

    # Retrieve the stored banner image from SickBeard's cache for this show.
    # @return image data (JPEG format)
    def get_banner
      @server.make_request('show.getbanner', tvdbid: @tvdbid)
    end

    # Retrieve the stored poster image from SickBeard's cache for this show.
    # @return image data (JPEG format)
    def get_poster
      @server.make_request('show.getposter', tvdbid: @tvdbid)
    end

    # Set a show's paused state in SickBeard.
    def pause
      @server.make_json_request('show.pause', tvdbid: @tvdbid, pause: 1)['message']
    end

    # Set a show's paused state in SickBeard.
    def unpause
      @server.make_json_request('show.pause', tvdbid: @tvdbid)['message']
    end

    # Retrieve a show's paused state in SickBeard.
    # @return [Boolean] indicating whether or not this Show is paused
    def paused?
      @server.make_json_request('show', tvdbid: @tvdbid)['data']['paused'] == 1
    end

    # Set desired quality of a show in SickBeard.
    # @option options [String, Array] :initial ([]) either a single quality SD
    #   or HD, or an array of allowable video quality definitions for downloading.
    # @option options [String, Array] :archive ([]) either a single quality SD
    #   or HD, or an array of allowable video quality definitions for archiving.
    def set_quality(options)
      initial = [*(options[:initial] || [])].join('|')
      archive = [*(options[:archive] || [])].join('|')
      @server.make_json_request('show.setquality', tvdbid: @tvdbid, initial: initial, archive: archive)['message']
    end

    def season_list
      if @season_list.empty?
        @season_list = @server.make_json_request('show.seasonlist', tvdbid: @tvdbid)['data'].sort
      end
      @season_list
    end

    # Returns episode statistics for this show.
    def stats
      @server.make_json_request('show.stats', tvdbid: @tvdbid)['data']
    end

    # Returns true if SickBeard's poster image cache is valid
    def has_cached_poster?
      @server.make_json_request('show.cache', tvdbid: @tvdbid)['data']['poster'] == 1
    end

    # Returns true if SickBeard's banner image cache is valid
    def has_cached_banner?
      @server.make_json_request('show.cache', tvdbid: @tvdbid)['data']['banner'] == 1
    end

    #  Update a show in SickBeard by pulling down information from TVDB and rescan
    #  local files.
    def update
      @server.make_json_request('show.update', tvdbid: @tvdbid)['message']
    end

    #  Refresh a show in SickBeard by rescanning local files.
    def refresh
      @server.make_json_request('show.refresh', tvdbid: @tvdbid)['message']
    end
  end
end
