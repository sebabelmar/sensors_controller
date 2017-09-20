require_relative "../spec_helper"

describe Building do
  before :all do
    building_args =
      {
        category: 'hotel',
        floors_config: FLOOR_CONFIG,
        appliances_config: APPLIANCE_CONFIG,
        restriction: RESTRICTION
      }

    @building = Building.new(building_args)
  end

  context "#initialize" do
    it "created a Building object" do
     expect(@building).to be_an_instance_of Building
    end
  end

  context "#restrictions" do
    it "returns a hash" do
      expect(@building.restrictions).to be_an_instance_of Hash
    end

    it "returns 40" do
      expect(@building.restrictions[1]).to eq(40)
    end

    xit "can be change" do
      # expect(building.restrictions[1]).to eq(40)
    end
  end
end
