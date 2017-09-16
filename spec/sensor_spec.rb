require "spec_helper"

=begin
Sensor should have simple state and the controller as a
subscriber.
Changes in the sensor are send to the any subscribed element.
=end


describe 'Sensor' do
  let(:controller){SensorController.new(Appliance)}
  let(:valid_args){
    {
      id: '1_1_0', #floor_main_sub
      name: 1,
      floor: 1,
      corridor: 'main',
      armed: false,
      last_armed: nil,
      observer: controller
    }
  }
  let(:sensor){Sensor.new(valid_args)}

  context "#initialize" do
    it "create a Sensor object" do
      expect(sensor).to be_an_instance_of Sensor
    end
  end

  context "#update" do
    before  do
      sensor.armed = true
    end
    it "notifies the controller about state changes" do
      expect(controller.state).to eq(['1_1_0'])
    end
  end
end
