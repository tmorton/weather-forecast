require 'rails_helper'

RSpec.describe ForecastLookup do
  let(:location) {
    Location.new(lat: 39.7456, lon: -97.0892, postal_code: "12345")
  }

  describe "#point_data" do
    it 'returns data when the request is successful' do
      VCR.use_cassette('weather_point') do
        lookup = ForecastLookup.new(location)
        pd = lookup.point_data

        expect(pd['properties']['forecastHourly']).to eq("https://api.weather.gov/gridpoints/TOP/32,81/forecast/hourly")
      end
    end

    it 'raises ForecastLookupError when there is a network error' do
      allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::Error)
      lookup = ForecastLookup.new(location)
      expect { lookup.point_data }.to raise_error(ForecastLookup::APIError)
    end
  end

  describe "#hourly_forecast_data" do
    it 'returns the hourly forecast data when the request is successful' do
      VCR.use_cassette('weather_hourly_forecast') do
        lookup = ForecastLookup.new(location)
        data = lookup.hourly_forecast_data

        expect(data['properties']['periods'][0]['number']).to eq(1)
        expect(data['properties']['periods'][0]['temperature']).to be_a_kind_of(Numeric)
      end
    end

    it 'raises ForecastLookup::APIError when there is a network error' do
      allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::Error)
      lookup = ForecastLookup.new(location)
      expect { lookup.hourly_forecast_data }.to raise_error(ForecastLookup::APIError)
    end

    it 'raises ForecastLookup::APIError when the point_data is unexpected' do
      lookup = ForecastLookup.new(location)
      allow(lookup).to receive(:point_data).and_return({})
      expect { lookup.hourly_forecast_data }.to raise_error(ForecastLookup::APIError)
    end
  end
end
