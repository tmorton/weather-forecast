# Weather Forecast Exercise

A simple weather forecast app. See [ASSIGNMENT.md](./ASSIGNMENT.md) for the original assignment.

Submitted by Tim Morton (tim@timothymorton.com).

## Setup and Running

The setup is similar to any other Rails app. There are no API keys or database setup needed.

- Ensure you have a valid Ruby install. `3.1.4` is the tested version; most version managers (ie `rbenv`) will detect it from the `.ruby-version` file.
- Install gems: `bundle install`
- Run specs: `rspec`
- Run server: `./bin/rails server`
- Visit `http://127.0.0.1:3000/`

## Design Notes

### API usage

This app uses two APIs - one for geocoding, and one for weather reports. I've set them up in two different ways.

#### Geocoding

For geocoding, I'm using the [Geocoder gem](https://github.com/alexreisner/geocoder), which is calling the [nominatim service](https://github.com/alexreisner/geocoder/blob/master/README_API_GUIDE.md#nominatim-nominatim) under the hood.

These requests are not cached, but the gem has caching options that could be configured.

#### Weather Forecasts

For weather forecasts, I wrote my own client for [weather.gov](https://www.weather.gov/documentation/services-web-api). While there are gems for this, I figured a hand-rolled client would be a better demonstration.

See [forecast_lookup.rb](./app/services/forecast_lookup.rb) for the network code.

### Caching

The weather forecasts are cached for 30 minutes, by postal code, as requested in the assignment.

The cache is the standard `Rails.cache`, which is configured to use `memory_store` in development. It will not persist between restarts of the server process.

I considered using ActiveRecord and storing the forecasts in a database, as the "cache". That may be useful for future features of this application, but it was overkill for the assignment given.

### Testing

My tests of the network code rely on the [VCR gem](https://github.com/vcr/vcr#vcr). It provides fast, consistent mocked network traffic, based on actual requests.

## End Notes

Thanks for looking this over. Hopefully this exercise demonstrates some skill - looking forward to talking further!
