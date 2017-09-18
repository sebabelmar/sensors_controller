require_relative "spec_helper"

describe Building do
  let(:floors){
    [
      {
        number: 1,
        qty_main_corridor: 1,
        qty_sub_corridor: 2
      },
      {
        number: 2,
        qty_main_corridor: 1,
        qty_sub_corridor: 2
      }
    ]
  }

  let(:appliances){
    [
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
  }

  let(:sensors){
    [
      {
        type: 'motion',
        location: 'main',
        qty_per_location: 1,
      },
      {
        type: 'motion',
        location: 'sub',
        qty_per_location: 1,
      }
    ]
  }

  let(:restriction){
    {
      level: 'floor',
      main_times: 10 ,
      sub_times: 15
    }
  }

  let(:valid_args) {
    {
      category: 'hotel',
      floors: floors,
      appliances: appliances,
      sensors: sensors,
      restriction: restriction
    }
  }

  let(:building) {Building.new(valid_args)}

  context "#initialize" do
    it "created a Building object" do
     expect(building).to be_an_instance_of Building
    end
  end

  context "#restrictions" do
    it "returns a hash" do
      expect(building.restrictions).to be_an_instance_of Hash
    end

    it "returns 40" do
      expect(building.restrictions[1]).to eq(40)
    end

    xit "can be change" do
      # expect(building.restrictions[1]).to eq(40)
    end
  end
end
