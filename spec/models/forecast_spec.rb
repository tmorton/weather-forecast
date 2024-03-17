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
end
