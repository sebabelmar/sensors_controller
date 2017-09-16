require_relative "spec_helper"

describe Building do
  let(:valid_args) {
    {
      category: 'hotel',
      floor_qty: 2,
      main_corridors_per_floor: 1,
      sub_corridors_per_floor: 2,
      lights_per_main_corridors: 1,
      lights_per_sub_corridors: 1,
      ac_per_main_corridors: 1,
      ac_per_sub_corridors: 1
    }
  }
  let(:building) {Building.new(valid_args)}

  context "#initialize" do
    it "created a Building object" do
     expect(building).to be_an_instance_of Building
    end
  end
end
