require "spec_helper"

=begin
Sensor should have simple state and the controller as a
subscriber.
Changes in the sensor are send to the any subscribed element.
=end


describe 'Sensor' do

  before :all do
    floors =
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

    restriction = {
        level: 'floor',
        main_times: 10 ,
        sub_times: 15
      }

    building_args =
      {
        category: 'hotel',
        floors: floors,
        appliances: [],
        sensors: [],
        restriction: restriction
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

  context ".turn_on" do
    before do
      Sensor.turn_on(@building, @sensor_controller )
    end

    it "initialize instances of it self" do
      expect(Sensor.sensors[Sensor.sensors.keys.sample]).to be_an_instance_of Sensor
    end

    it "Class.on is true" do
      expect(Sensor.on).to be true
    end

    it "@@sensors hash of Sensor instances as values" do
      expect(Sensor.sensors.values.map(&:class).uniq.pop).to  eq Sensor
    end
  end

  context "#update" do
    before  do
      @sensor       = Sensor.sensors[Sensor.sensors.keys.sample]
      @sensor.armed = true
      @look_up_id   = @sensor.id
    end

    it "sensor instance state can be change" do
      expect(Sensor.sensors[@look_up_id].armed).to be true
    end

    it "notifies the controller about state changes" do
      expect(@sensor_controller.test_var).to be true
    end
  end
end
