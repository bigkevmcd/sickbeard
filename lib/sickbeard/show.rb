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
    #  @return [Array(Integer)] list of known Series for this Show
    # @!attribute [r] server
    #  @return [SickBeard::Client] the server this Show was loaded from
    # @!attribute [r] tvdbid
    #  @return [Integer] the tvdbid for this Show
    # @!attribute [r] quality
    #  @return [String] The download quality for this Show e.g. SD
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

    # Create a new Show
    # @option options [String] :name ("") The name for this show
    # @option options [Array(String)] :genres ("") array of genres applicable to this show.
    # @return [Object] the object.
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
  end
end
