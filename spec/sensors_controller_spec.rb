require 'rspec'
require_relative "../app/SensorsController"

describe SensorController do
  let(:sensor_controller) { SensorController.new }

  context "#initialize" do
    it "creates a SensorController object" do
      expect(sensor_controller).to be_an_instance_of SensorController
    end
  end

  context "#status" do
    it "should return on" do
      expect(sensor_controller.status).to eq "on"
    end
  end
end
