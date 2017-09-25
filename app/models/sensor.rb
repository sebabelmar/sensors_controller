require "observer"
# Description:
#   This class is a sensor factory where its instances dispatches state (are/disarm) reports
#   to a subscriber (OperationsController).
#   Its responsability is to create instances upon floor configuration and subscribe the controller to them.
#   And maintain a collection of instances in compliance with the provided configuration.
#   Therefore this class should not be instantiate manually.

# Dependencies: n/a

# Attributes:
#   args= {
#     id: "<floor_number>_<main_corridor_number>_<sub_corridor_or_zero>",
#     floor_number: <number>,
#     location: <string> 'main' || 'sub',
#     armed: <boolean>,
#    }

# External API:
#         class:
#           .turn_on(<building instance>, <controller.instance>)  => Allocates arguments to class variables
#                                                                 => Executes factory method
#           .all      => returns a collection of sensors created upon Bulding#floors_config; @@sensors
#           .arm(floor_number, corridor_number, sub_number=0)      => finds an element of the sensors collection and changes attr armed to true
#           .disarm(floor_number, corridor_number, sub_number=0)   => finds an element of the sensors collection and changes attr armed to false
#         instance:
#           .armed            => changes attr armed and triggers notification to subscriber

class Sensor
  include Observable

  @@controller  = nil
  @@sensors     = {}
  @@turned_on   = false

  attr_reader :id, :armed, :floor_number, :location

  def initialize(args)
    @id           = args[:id]
    @floor_number = args[:floor_number]
    @location     = args[:location]
    @armed        = false

    # Observer is added on initialization (SensorController)
    add_observer(@@controller)
  end

  # Observer is notified on changes (SensorController)
  def armed=(armed_update)
    changed
    @armed = armed_update
    notify_observers(self)
  end

  def self.turn_on(building, controller)
    unless(building.class == Building && controller.class == OperationsController)
      raise(ArgumentError, "Please make sure that your are instatiating this class with instances of the appropiate classes.")
    end

    @@building   = building
    @@controller = controller
    factory unless @@turned_on
    @@turned_on   = true
  end

  # Executes initialization upon building floor configuration.
  def self.factory

    # Assuming 1 sensor per location
    @@building.floors_config.each do |floor|
      floor_number = floor[:number]

      floor[:main_corridors].each do |main|
        main_number = main[:number]
        self.create('main', floor_number, main_number)

        main[:sub_corridors].each do |sub|
          self.create('sub', floor_number, main_number, sub[:number])
        end
      end
    end
  end

  # Creates instances of itself and it organize it in a Hash were the keys are the elements ids
  # and values are instances of this same class.
  def self.create(location, floor_number, main_number, sub_number=0)
    # Add validation like unique ids.

    id = "#{floor_number}_#{main_number}_#{sub_number}"
    @@sensors[id] = Sensor.new({
      id: id, floor_number: floor_number, location: location
      })
  end

  # Returns collection
  def self.all
    @@sensors
  end

  # I would make this method more flexible
  # Finds an element in the main collection and turns its state into armed
  def self.arm(floor_number, corridor_number, sub_number=0)
    find_update_armed(true, floor_number, corridor_number, sub_number)
  end

  # Finds an element in the main collection and turns its state into disam
  def self.disarm(floor_number, corridor_number, sub_number=0)
    find_update_armed(false, floor_number, corridor_number, sub_number)
  end

  # This method could be a generic update.
  # Finds an element and changes its state after validation
  def self.find_update_armed(arm_value, floor_number, corridor_number, sub_number=0)
    target_sensor = @@sensors["#{floor_number}_#{corridor_number}_#{sub_number}"]

    if (target_sensor == nil)
      raise(ArgumentError, "Sensor not found, please check floor, corridor and sub corridor data.")
    else
      target_sensor.armed = arm_value
    end
  end
end
