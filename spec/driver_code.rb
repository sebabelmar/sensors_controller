require_relative 'spec_helper'

# # Driver Code
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

OperationsController.new(valid_args).turn_on

Appliance.print_state
Sensor.arm(1,1,2)
Appliance.print_state
Sensor.arm(1,1,1)
Appliance.print_state
Sensor.disarm(1,1,1)
Appliance.print_state
