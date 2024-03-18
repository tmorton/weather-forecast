# Represents a weather forecast at a particular time, for a particular location.
class Forecast
  include ActiveModel::Model

  def initialize(hourly_forecast_data)
    @hourly_forecast_data = hourly_forecast_data
  end

  def current_temperature
    degrees = @hourly_forecast_data.dig('properties', 'periods', 0, 'temperature')
    unit = @hourly_forecast_data.dig('properties', 'periods', 0, 'temperatureUnit')

    return "unknown" unless degrees
    "#{degrees}° #{unit}"
  end

  def short_forecast
    @hourly_forecast_data.dig('properties', 'periods', 0, 'shortForecast')
  end

  def from_cache?
    @hourly_forecast_data.dig('from_cache')
  end
end
