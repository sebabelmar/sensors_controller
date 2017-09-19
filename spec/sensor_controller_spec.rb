require_relative "spec_helper"

describe SensorController do
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

  let(:building_args) {
    {
      category: 'hotel',
      floors: floors,
      appliances: appliances,
      sensors: sensors,
      restriction: restriction
    }
  }

  let(:building) {Building.new(building_args)}
  let(:sensor) {Sensor}
  let(:appliance) {Appliance}

  let(:valid_args){
    {
      building: building,
      sensor: sensor,
      appliance: appliance
    }
  }
  let(:sensor_controller) { SensorController.new(valid_args) }

  context "#initialize" do
    it "creates a SensorController object" do
      expect(sensor_controller).to be_an_instance_of SensorController
    end
  end

  context "#on" do
    it "should start as false" do
      expect(sensor_controller.on).to be false
    end
  end

  context "#activated" do
    it "should start as false" do
      expect(sensor_controller.activated).to be false
    end
  end

  context "#turn_on" do
    it "should return true" do
      expect(sensor_controller.turn_on).to be true
    end
  end

end
