require 'rails_helper'

RSpec.describe YardsSearchFacade do
  describe "class methods" do
    describe ".make_search" do
      it "makes a search with a zipcode" do
        params = {location: "19125", controller: "api/v1/yards/search", action: "search"}
        yard_1 = create(:yard, zipcode: '19125')
        yard_2 = create(:yard, zipcode: '54678')
        yard_3 = create(:yard, zipcode: '19125')
        yard_4 = create(:yard, zipcode: '11122')
        yard_5 = create(:yard, zipcode: '19125')

        expect(YardsSearchFacade.make_search(params)).to eq([yard_1, yard_3, yard_5])
      end

      it "makes a search with a zipcode and purposes" do
        params = {location: "19125", purposes: ["pet yard"], controller: "api/v1/yards/search", action: "search"}
        yard_1 = create(:yard, zipcode: '19125')
        yard_2 = create(:yard, zipcode: '19125')
        yard_3 = create(:yard, zipcode: '19125')
        yard_4 = create(:yard, zipcode: '54678')
        yard_5 = create(:yard, zipcode: '11122')
        pet_yard = create(:purpose, name: "Pet Yard")
        party_yard = create(:purpose, name: "Party Yard")
        hobby_yard = create(:purpose, name: "Hobby Yard")
        yard_1.purposes << pet_yard
        yard_3.purposes << pet_yard
        yard_5.purposes << pet_yard
        yard_1.purposes << hobby_yard
        yard_3.purposes << hobby_yard
        yard_5.purposes << hobby_yard
        yard_4.purposes << hobby_yard
        yard_2.purposes << party_yard
        yard_4.purposes << party_yard

        expect(YardsSearchFacade.make_search(params)).to eq([yard_1, yard_3])
      end
    end
  end
end
