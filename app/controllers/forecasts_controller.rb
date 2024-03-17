class ForecastsController < ApplicationController
  def index
    @address_search = params[:address_search]

    if @address_search
      # Geocode lookup
      # Redirect to show page with authoritative location
      redirect_to action: "show", id: "unknown", address_search: @address_search
    end
  end

  def show
    @address_search = params[:address_search]
  end
end
