require_relative "spec_helper"

describe Building do
  before :all do
    floors_config =
      [
        {
          number: 1,
          main_corridors: [{
              number: 1,
              sub_corridors: [{number:1},{number:2}]
            }]
        },
        {
          number: 2,
          main_corridors: [{
              number: 1,
              sub_corridors: [{number:1},{number:2}]
            }]
        },
      ]

    appliances_config = [
          {
            type: 'ac',
            location: 'main',
            qty_per_location: 1,
            energy_consuption: 10
          },
          {
            type: 'ac',
            location: 'sub',
            qty_per_location: 1,
            energy_consuption: 10
          },
          {
            type: 'light',
            location: 'main',
            qty_per_location: 1,
            energy_consuption: 5
          },
          {
            type: 'light',
            location: 'sub',
            qty_per_location: 1,
            energy_consuption: 5
          },
        ]

    restriction = {
        level: 'floor',
        main_times: 10 ,
        sub_times: 15
      }

    building_args =
      {
        category: 'hotel',
        floors_config: floors_config,
        appliances_config: appliances_config,
        sensors: [],
        restriction: restriction
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
