require_relative "../spec_helper"

describe 'Appliance' do

  before :all do
    building_args =
      {
        category: 'hotel',
        floors_config: FLOORS_CONFIG,
        appliances_config: APPLIANCES_CONFIG,
        restriction: RESTRICTION
      }

    @building = Building.new(building_args)

    valid_args =
      {
        building: @building,
        sensor: Sensor,
        appliance: Appliance
      }

    @soperations_controller = OperationsController.new(valid_args)
  end

  context ".turn_on" do
    before do
      Appliance.turn_on(@building)
    end

    it "initialize instances of it self" do
      expect(Appliance.all[Appliance.all.keys.sample]).to be_an_instance_of Appliance
    end

    it "@@appliances hash of Appliance instances as values" do
      expect(Appliance.all.values.map(&:class).uniq.pop).to eq Appliance
    end
  end

  context "#update" do
    before  do
      @sensor       = Appliance.all["1_1_1"]
      @sensor.armed = true
      @look_up_id   = @sensor.id + "_light"
    end

    xit "sensor instance state can be change" do
      expect(Appliance.all[@look_up_id].armed).to be true
    end

    xit "notifies the controller about state changes" do
      expect(@soperations_controller.test_var).to be true
    end
  end
end
