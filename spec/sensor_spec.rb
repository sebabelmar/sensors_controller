require "spec_helper"

=begin
Sensor should have simple state and the controller as a
subscriber.
Changes in the sensor are send to the any subscribed element.
=end


describe 'Sensor' do

  before :all do
    floors_config =
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

    appliances_config = [
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

    restriction = {
        level: 'floor',
        main_times: 10 ,
        sub_times: 15
      }

    building_args =
      {
        category: 'hotel',
        floors_config: floors_config,
        appliances_config: appliances_config,
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
      expect(Sensor.all[Sensor.all.keys.sample]).to be_an_instance_of Sensor
    end

    it "Class.on is true" do
      expect(Sensor.on).to be true
    end

    it "@@sensors hash of Sensor instances as values" do
      expect(Sensor.all.values.map(&:class).uniq.pop).to  eq Sensor
    end
  end

  context "#update" do
    before  do
      @sensor       = Sensor.all[Sensor.all.keys.sample]
      @sensor.armed = true
      @look_up_id   = @sensor.id
    end

    it "sensor instance state can be change" do
      expect(Sensor.all[@look_up_id].armed).to be true
    end

    it "notifies the controller about state changes" do
      expect(@sensor_controller.test_var).to be true
    end
  end
end
