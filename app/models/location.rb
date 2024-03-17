class Location
  include ActiveModel::Model

  attr_accessor :display_name, :lat, :lon, :postal_code

  # Search for a Location, using an external geocoding service.
  # Returns nil if the search did not find a location
  def self.search(address_search)
    result = Geocoder.search(address_search).first
    return nil unless result

    Location.new({
      display_name: result.display_name,
      lat: result.latitude.to_s,
      lon: result.longitude.to_s,
      postal_code: result.postal_code.to_s,
    })
  end
end
