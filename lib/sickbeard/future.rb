require 'json'
require 'uri'
require 'cgi'

module SickBeard

  class Base
    def future
      response = make_request('future')
      JSON.parse(response)
    end
  end
end
