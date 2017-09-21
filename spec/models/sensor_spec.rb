require_relative "../spec_helper"

=begin
Sensor should have simple state and the controller as a
subscriber.
Changes in the sensor are send to the any subscribed element.
=end


describe 'Sensor' do

  before :all do
    building_args =
      {
        category: 'hotel',
        floors_config: FLOORS_CONFIG,
        appliances_config: APPLIANCES_CONFIG,
        restriction: RESTRICTION
      }

    building = Building.new(building_args)

    valid_args =
      {
        building: building,
        sensor: Sensor,
        appliance: Appliance
      }

    @operations_controller = OperationsController.new(valid_args)
    @operations_controller.turn_on
  end

  context ".turn_on" do
    it "initialize instances of it self" do
      expect(Sensor.all[Sensor.all.keys.sample]).to be_an_instance_of Sensor
    end

    it "@@sensors hash of Sensor instances as values" do
      expect(Sensor.all.values.map(&:class).uniq.pop).to  eq Sensor
    end
  end

  context "#update" do
    it "turns appliance on" do
      Sensor.arm(1,1,2)
      
      expect(Appliance.find('light', 1, 1, 2))
    end
  end
end
