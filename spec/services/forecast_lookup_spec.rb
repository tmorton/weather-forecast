require 'rails_helper'

RSpec.describe ForecastLookup do
  let(:location) {
    Location.new(lat: 39.7456, lon: -97.0892, postal_code: "12345")
  }

  describe "#hourly_forecast_data" do
    it 'returns the hourly forecast data when the request is successful' do
      VCR.use_cassette('weather_hourly_forecast') do
        lookup = ForecastLookup.new(location)
        data = lookup.hourly_forecast_data

        expect(data['properties']['periods'][0]['number']).to eq(1)
        expect(data['properties']['periods'][0]['temperature']).to be_a_kind_of(Numeric)
      end
    end

    it 'sets from_cache to false when the request was not from cache' do
      VCR.use_cassette('weather_hourly_forecast') do
        lookup = ForecastLookup.new(location)
        data = lookup.hourly_forecast_data

        expect(data['from_cache']).to eq(false)
      end
    end

    it 'sets from_cache to true when the request was from cache' do
      lookup = ForecastLookup.new(location)
      expect(Rails.cache).to receive(:fetch).and_return({})

      # No VCR cassette loaded for this test, since it should not hit the network
      data = lookup.hourly_forecast_data

      expect(data['from_cache']).to eq(true)
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
