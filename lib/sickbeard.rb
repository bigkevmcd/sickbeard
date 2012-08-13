require 'net/http'
require 'uri'
require 'json'
require 'cgi'

module SickBeard
  # This class provides all the methods for using the SickBeard API.
  class Base

    # @option options [String] :access_key_id ("") The user's AWS Access Key ID
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

    def make_request(cmd, options = {})
      options = { cmd: cmd }.merge(options)
      path = "/api/#{@api_key}/"
      uri = URI::join(URI.parse(@server), path)
      uri.query = URI.encode_www_form( options )
      Net::HTTP.get(uri)
    end

    def make_json_request(cmd, options = {})
      response = JSON.parse(make_request(cmd, options))
      raise Error.new(response['message']) if response['result'] != 'success'
      response
    end
  end

  class Error < RuntimeError; end
end

Dir[File.join(File.dirname(__FILE__), 'sickbeard/**/*.rb')].sort.each { |lib| require lib }
