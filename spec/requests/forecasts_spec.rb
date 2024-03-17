require 'rails_helper'

RSpec.describe "Forecasts", type: :request do
  describe "GET /" do
    it "returns a successful response" do
      get "/"
      expect(response).to be_successful
    end
  end
end
