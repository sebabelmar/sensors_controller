require_relative "../spec_helper"

describe SensorController do
  before :all do
    building_args =
      {
        category: 'hotel',
        floors_config: FLOOR_CONFIG,
        appliances_config: APPLIANCE_CONFIG,
        restriction: RESTRICTION
      }

    @building = Building.new(building_args)

    valid_args =
      {
        building: @building,
        sensor: Sensor,
        appliance: Appliance
      }

    @sensor_controller = SensorController.new(valid_args)
  end

  context "#initialize" do
    it "creates a SensorController object" do
      expect(@sensor_controller).to be_an_instance_of SensorController
    end
  end

  context "#on" do
    it "should start as false" do
      expect(@sensor_controller.on).to be false
    end
  end

  context "#turn_on" do
   xit "should return true" do
      expect(@sensor_controller.turn_on).to be true
    end
  end

end
