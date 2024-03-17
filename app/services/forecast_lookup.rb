# This class looks up a forecast from the NOAA API.
class ForecastLookup

  # Somthing went wrong looking up our forecast.
  #   (In a real app, we'd have several further subclasses to categorize our errors)
  class APIError < StandardError; end

  # Returns a forecast for the given Location
  def self.by_location(location)
    return nil if location.nil?
    new(location).forecast
  end

  def initialize(location)
    @location = location
  end

  def forecast
    Forecast.new(hourly_forecast_data)
  end

  # Retrieve information about the location from the API
  # We need this to get the "grid location", which is how NOAA
  # categorizes locations.
  def point_data
    points_str = [@location.lat, @location.lon].join(',')
    data = connection.get("/points/#{points_str}").body
    data
  rescue Faraday::Error => e
    raise APIError.new(e)
  end

  def hourly_forecast_data
    url = point_data.dig('properties', 'forecastHourly')
    raise APIError.new("Could not locate forecast URL") unless url

    data = connection.get(url).body
    data
  rescue Faraday::Error => e
    raise APIError.new(e)
  end

  private

  def connection
    @connection ||= Faraday.new(url: "https://api.weather.gov") do |f|
      f.request :json
      f.response :json
      f.response :raise_error
      f.response :logger
      f.use FaradayMiddleware::FollowRedirects
    end
  end
end
