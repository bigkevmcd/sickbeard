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
    # @return [Object] the object.
    def future(options = {})
      filter = (options[:type] || []).join('|')
      make_json_request('future', type: filter, sort: options[:sort])['data']
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
        Show.from_response(self, result['tvdbid'], name: result['name'])
      end
    end
  end
end
