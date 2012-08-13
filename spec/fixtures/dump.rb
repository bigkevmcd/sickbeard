#!/usr/bin/env ruby

require 'yaml'
require 'json'

show = YAML::load( File.open( ARGV[0] ) )
# show['http_interactions'].each {|request| puts JSON.pretty_generate(JSON.parse(request['response']['body']['string'])) }
puts JSON.pretty_generate(JSON.parse(show['http_interactions'][2]['response']['body']['string']))
