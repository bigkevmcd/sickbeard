require 'net/http'
require 'uri'
require 'json'
require 'cgi'

module SickBeard
  # This class provides all the methods for using the SickBeard API.
  class Base

    # @option options [String] :api_key ("") The SickBeard username for access.
    # @option options [String] :server ("") The server API endpoint.
    # @return [Object] the object.
    def initialize(options = {})

      options = { api_key: '',
                  server: '',
                  }.merge(options)

      @server = options[:server]
      @api_key = options[:api_key]
      raise ArgumentError, 'No :api_key provided' if options[:api_key].nil? || options[:api_key].empty?
      raise ArgumentError, 'No :server provided' if options[:server].nil? || options[:server].empty?
    end

    # Makes an API call to a SickBeard server
    #
    # @param [String] cmd SickBeard API call to request
    # @param [Hash] options the options to make the API call with, these are
    #   passed as GET parameters to the SickBeard server.
    # @return [String] the HTTP response
    def make_request(cmd, options = {})
      options = { cmd: cmd }.merge(options)
      path = "/api/#{@api_key}/"
      uri = URI::join(URI.parse(@server), path)
      uri.query = URI.encode_www_form( options )
      Net::HTTP.get(uri)
    end

    # Makes an API call to a SickBeard server returns JSON parsed result
    # @see make_request
    # @return [Hash] JSON parsed result from the remote server
    def make_json_request(cmd, options = {})
      response = JSON.parse(make_request(cmd, options))
      raise Error.new(response['message']) if response['result'] != 'success'
      response
    end
  end

  # Raised when the remote server returns a non-success response
  class Error < RuntimeError; end
end

Dir[File.join(File.dirname(__FILE__), 'sickbeard/**/*.rb')].sort.each { |lib| require lib }
