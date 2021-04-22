require 'rails_helper'

RSpec.describe YardsFacade do
  describe "class methods" do
    it ".find_yards" do
      @yard1 = create(:yard, host_id: 1)
      @yard2 = create(:yard, host_id: 2)
      @yard3 = create(:yard, host_id: 1)
      @yard4 = create(:yard, host_id: 2)
      @yard5 = create(:yard, host_id: 1)
      @yard6 = create(:yard, host_id: 1)

      expect(YardsFacade.find_yards(1, 1)).to eq([@yard1, @yard3, @yard5, @yard6])
    end

    describe ".create_yard" do
      before :each do
        @yard_params = ({
                        id: 1,
                        host_id: 1,
                        email: "host_eamil@domain.com",
                        name: 'yard',
                        street_address: '123 Fake St.',
                        city: 'Denver',
                        state: 'CO',
                        zipcode: '12345',
                        price: 20.00,
                        description: 'description',
                        availability: 'availability',
                        payment: 'venmo',
                        photo_url_1: 'url1',
                        photo_url_2: 'url2',
                        photo_url_3: 'url3',
                      })

        @purposes = create_list(:purpose, 3)
      end

      it "creates a yard if params and purposes are provided" do
        expect(YardsFacade.create_yard(@yard_params, @purposes)).to be_a(Yard)
      end

      it "returns an error if purposes are not provided" do
        expect(YardsFacade.create_yard(@yard_params, nil)[:error]).to eq("You must select at least one purpose")
      end
    end

    describe ".update_yard" do
      before :each do
        @yard = create(:yard)
        @yard_params = ({
                        id: 1,
                        host_id: 1,
                        email: "host_eamil@domain.com",
                        name: 'yard',
                        street_address: '123 Fake St.',
                        city: 'Denver',
                        state: 'CO',
                        zipcode: '12345',
                        price: 20.00,
                        description: 'description',
                        availability: 'availability',
                        payment: 'venmo',
                        photo_url_1: 'url1',
                        photo_url_2: 'url2',
                        photo_url_3: 'url3',
                      })

        @purposes = create_list(:purpose, 3)
      end

      it "creates a yard if params and purposes are provided" do
        expect(YardsFacade.update_yard(@yard.id, @yard_params, @purposes)).to be_a(Yard)
      end

      it "returns an error if purposes are not provided" do
        expect(YardsFacade.update_yard(@yard.id, @yard_params, nil)[:error]).to eq("You must select at least one purpose")
      end
    end

    it ".create_yard_purposes" do
      yard = create(:yard)
      purpose1 = create(:purpose)
      purpose2 = create(:purpose)
      purpose_ids = [purpose1.id, purpose2.id]

      YardsFacade.create_yard_purposes(yard, purpose_ids)

      expect(YardPurpose.all.count).to eq(2)
    end
  end
end
