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
end
