require 'json'
require 'uri'
require 'cgi'

module SickBeard

  class Base

    # Returns misc SickBeard related information.
    def sb
      make_request('sb')
    end

    # Returns the upcoming episodes for the shows currently added in the
    # users' database.
    #
    # @option options [String] :sort (nil) Option to sort the results, date/network/name
    #
    # @option options [Array<String>] :filter (nil) Option to filter the results, missed/today/soon/later
    #   missed - show's date is older than today
    #   today - show's date is today
    #   soon - show's date greater than today but less than a week
    #   later - show's date greater than a week
    #
    def future(options = {})
      filter = (options[:type] || []).join('|')
      make_request('future', type: filter, sort: options[:sort])
    end

    # Returns global episode and show statistics.
    def shows_stats
      make_request('shows.stats')
    end

    # Returns a list of all shows in SickBeard.
    def shows(options = {})
      make_request('shows', sort: options[:sort])
    end
  end
end
