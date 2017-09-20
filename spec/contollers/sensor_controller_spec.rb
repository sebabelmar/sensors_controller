require_relative "../spec_helper"

describe OperationsController do
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

    @operations_controller = OperationsController.new(valid_args)
  end

  context "#initialize" do
    it "creates a OperationsController object" do
      expect(@operations_controller).to be_an_instance_of OperationsController
    end
  end

  context "#on" do
    it "should start as false" do
      expect(@operations_controller.on).to be false
    end
  end

  context "#turn_on" do
   xit "should return true" do
      expect(@operations_controller.turn_on).to be true
    end
  end

end
