require_relative 'spec_helper'

# # Driver Code
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


building = Building.new(building_args)

valid_args =
  {
    building: building,
    sensor: Sensor,
    appliance: Appliance
  }

sensor_controller = OperationsController.new(valid_args)

Appliance.turn_on(building)
Appliance.print_state
Appliance.energy_report

Sensor.turn_on(building, sensor_controller)
p Sensor.all
