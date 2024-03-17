require 'rails_helper'

RSpec.describe Location, type: :model do
  describe '.search' do
    it 'should set the attributes for a valid address' do
      address_search = '1600 pennsylvania ave washington dc'
      VCR.use_cassette('lookup_white_house') do
        location = Location.search(address_search)

        expect(location.display_name).to eq('White House, 1600, Pennsylvania Avenue Northwest, Ward 2, Washington, District of Columbia, 20500, United States')
        expect(location.lat).to eq('38.897699700000004')
        expect(location.lon).to eq('-77.03655315')
        expect(location.postal_code).to eq('20500')
      end
    end

    it 'returns nil for an invalid address' do
      address_search = 'this is not a real address'
      VCR.use_cassette('lookup_fake_address') do
        location = Location.search(address_search)

        expect(location).to be_nil
      end
    end
  end
end
