require_relative 'spec_helper'

# # Driver Code
building_args =
  {
    category: 'hotel',
    floors_config: FLOOR_CONFIG,
    appliances_config: APPLIANCE_CONFIG,
    restriction: RESTRICTION
  }

building = Building.new(building_args)

valid_args =
  {
    building: @building,
    sensor: Sensor,
    appliance: Appliance
  }

operations_controller = OperationsController.new(valid_args)

Appliance.turn_on(building)
Appliance.print_state
Appliance.energy_report

Sensor.turn_on(building, operations_controller)
Sensor.all
