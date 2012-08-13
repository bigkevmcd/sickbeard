# Sickbeard

This provides a basic API for interacting with the SickBeard PVR.

## Installation

Add this line to your application's Gemfile:

    gem 'sickbeard'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sickbeard

## Usage

    require 'sickbeard'

    client = SickBeard::Client.new(server: 'http://example.com/', api_key: '1234568901')

    puts SickBeard.shows_stats

### Fetching a Show

    show = client.show(17522)

    show.paused?

    show.pause

    show.unpause

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
