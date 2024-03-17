class ForecastsController < ApplicationController
  def index
    @address_search = params[:address_search]

    if @address_search
      @location = Location.search(@address_search)
      @forecast = ForecastLookup.by_location(@location)
    end
  rescue ForecastLookup::APIError => e
    @api_error = true
    puts e.inspect
  end

end
