module SickBeard

  class Client < Base

    # Returns misc SickBeard related information.
    def sb
      make_json_request('sb')
    end

    # Returns the upcoming episodes for the shows currently added in the
    # users' database.

    # @param [Hash] options optional parameters for the SickBeard API call
    # @option options [String] :sort (nil) Option to sort the results:
    #   * date 
    #   * network
    #   * name
    #
    # @option options [Array<String>] :filter (nil) Option to filter the results:
    #   * missed - show's date is older than today
    #   * today - show's date is today
    #   * soon - show's date greater than today but less than a week
    #   * later - show's date greater than a week
    # @return [Array<Episode>]
    def future(options = {})
      filter = (options[:type] || []).join('|')
      upcoming = make_json_request('future', type: filter, sort: options[:sort])['data']
      episodes = {}
      upcoming.keys.each do |section|
        episodes[section] = []
        upcoming[section].collect do |item|
          # {"airdate"=>"2012-08-25", "airs"=>"Saturday 7:00 PM", "ep_name"=>"Asylum Of The Daleks", 
          #  "ep_plot"=>"", "episode"=>1, "network"=>"BBC One", "paused"=>0, "quality"=>"SD", "season"=>7,
          # "show_name"=>"Doctor Who (2005)", "show_status"=>"Continuing", "tvdbid"=>78804, "weekday"=>6}
          show = Show.new(tvdbid: item['tvdbid'], name: item['show_name'])
          episodes[section].push Episode.new({airdate: item['airdate'], name: item['item_name'], episode: item['episode'], show: show, season: item['season']})
        end
      end
      return episodes
    end

    # Returns global episode and show statistics.
    def shows_stats
      make_json_request('shows.stats')['data']
    end

    # Returns a list of all shows in SickBeard.
    def shows(options = {})
      make_json_request('shows', sort: options[:sort])['data'].collect do |key, response|
        # SickBeard API returns different things based on your sort.
        if options[:sort] == 'name'
          response['show_name'] = key
          show_id = response['tvdbid']
        else
          show_id = key
        end
        Show.from_response(self, show_id, response)
      end
    end

    # Returns information for a given show.
    # @param [String] show_id the tvdbid for the show to fetch
    # @return [SickBeard::Show]
    def show(show_id)
      Show.from_response(self, show_id, make_json_request('show', tvdbid: show_id)['data'])
    end

    # Search for Shows by name
    # @param [String] name the show to match on.
    def searchtvdb(name)
      make_json_request('sb.searchtvdb', name: name)['data']['results'].collect do |result|
        Show.from_response(self, result['tvdbid'], result)
      end
    end
  end
end
