class ForecastsController < ApplicationController
  def index
    @address_search = params[:address_search]

    if @address_search
      @location = Location.search(@address_search)
      @forecast = nil # ForecastLookup.by_location(@location)
    end
  end

end
