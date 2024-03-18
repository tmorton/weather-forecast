require 'rails_helper'

RSpec.describe Forecast do
  describe '#current_temperature' do
    it 'returns the current temperature' do
      forecast_data = {
        'properties' => {
          'periods' => [
            {
              'temperature' => 25,
              'temperatureUnit' => 'F'
            }
          ]
        }
      }
      forecast = Forecast.new(forecast_data)
      expect(forecast.current_temperature).to eq("25° F")
    end

    it 'returns unknown when there is no current temperature' do
      forecast_data = {
        'properties' => {
          'periods' => []
        }
      }
      forecast = Forecast.new(forecast_data)
      expect(forecast.current_temperature).to eq("unknown")
    end
  end

  describe '#short_forecast' do
    it 'returns the short forecast' do
      forecast_data = {
        'properties' => {
          'periods' => [
            {
              'shortForecast' => 'Sunny'
            }
          ]
        }
      }
      forecast = Forecast.new(forecast_data)
      expect(forecast.short_forecast).to eq('Sunny')
    end
  end

  describe '#from_cache?' do
    it 'returns true when forecast data is from cache' do
      forecast_data = {
        'from_cache' => true
      }
      forecast = Forecast.new(forecast_data)
      expect(forecast.from_cache?).to be true
    end

    it 'returns false when forecast data is not from cache' do
      forecast_data = {
        'from_cache' => false
      }
      forecast = Forecast.new(forecast_data)
      expect(forecast.from_cache?).to be false
    end
  end
end
