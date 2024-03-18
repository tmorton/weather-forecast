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

  def hourly_forecast_data
    from_cache = true

    cache_key = "forecast/postal_code/#{@location.postal_code}"
    data = Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
      from_cache = false
      fetch_hourly_forecast_data
    end
    data.merge({ 'from_cache' => from_cache })
  end

  private

  def connection
    @connection ||= Faraday.new(url: "https://api.weather.gov") do |f|
      f.request :json
      f.response :json
      f.response :raise_error
      f.response :follow_redirects
    end
  end

  def point_data
    points_str = [@location.lat, @location.lon].join(',')
    data = connection.get("/points/#{points_str}").body
    data
  rescue Faraday::Error => e
    raise APIError.new(e)
  end

  def fetch_hourly_forecast_data
    url = point_data.dig('properties', 'forecastHourly')
    raise APIError.new("Could not locate forecast URL") unless url

    data = connection.get(url).body
    data
  rescue Faraday::Error => e
    raise APIError.new(e)
  end
end
