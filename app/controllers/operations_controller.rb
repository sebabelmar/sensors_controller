require "observer"
# Description:
#   This class is the operations controller. It recieves intructions to turn on
#   appliances and sensors given a Building configuration.
#   It recieves messages of sensors state changes and notifies Application about this
#   changes. It process information in order to send the correct message to Appliance.

# Dependencies: Bulding#instance, Sensor, Appliance, View.

# Attributes:
#   args= {
#     on: <boolean>,
#     building: <Building#instance>,
#     sensor: <Class>,
#     appliance: <Class>,
#     view: <Class>,
#   }

# External API:
#         instance:
#           #on             => Attribute accesor to change instance state.
#           #print_state    => Prints state report via View.
#           #inputs_runner  => Runs input console prompt


class OperationsController
  include Observable
  attr_reader :on

  def initialize(args)
    @on             = false
    @building       = args[:building]
    @sensor         = args[:sensor]
    @appliance      = args[:appliance]
    @view           = args[:view]

    add_observer(@appliance)
  end

  # Turns on:
  #   => Create all sensors per floor
  #   => Create all appliances per floor
  #   => Flags the controller as on
  def turn_on
    @sensor.turn_on(@building, self)
    @appliance.turn_on(@building)
    @on = true
  end


  # Receives messages from sensors.
  def update(sensor)
    analyze(sensor)
  end

  # Analyses sensor information to dispatch instructions to Appliance
  def analyze(sensor)
    target_floor, target_corridor, target_sub = sensor.id.split('_')
    command = sensor.armed ? 'on' : 'off'

    raise(StandardError, 'Main corridors wont react to sensor information.') if target_sub == 0

    # Dispatch instructions related to lights appliances
    # Checks for target main or sub and its corresponding configuration
    if (target_sub != 0 && !RESTRICTION[:sub_lights_always_on])
      send_instructions_to_observer({id: "#{sensor.id}", command: command, type: 'light', energy_balance: nil})
    end

    # Gets enegy report from Appliance and performs calculations
    energy_report = @appliance.energy_report[target_floor.to_s]
    energy_balance = @building.restrictions[target_floor.to_s] - energy_report[:current_usage]

    # Dispatch instructions related to air conditioning appliances upon energy analysis
    if (energy_balance < 0)
      send_instructions_to_observer({id: "#{sensor.id}", command: 'off', type: 'ac', energy_balance: energy_balance})
    elsif(energy_balance > 0 && energy_report[:saving_mode])
      send_instructions_to_observer({id: "#{sensor.id}", command: 'on', type: 'ac', energy_balance: energy_balance})
    end
  end

  # Notifies Appliance using a previously formated message
  # Message = {id: <string>, command: <on || off> , type: <ligt || ac>, energy_balance: <number>}
  def send_instructions_to_observer(message)
    changed
    notify_observers(message)
  end

  # Print states using view
  def print_state
    @view.print_state
  end

  def sensor_input(command, floor_number, corridor_number, sub_number)
    raise(ArgumentError, "Please check command parameter.") unless (command.downcase == 'disarm') || (command.downcase == 'arm')

    if(command == 'arm')
      Sensor.arm(floor_number, corridor_number, sub_number)
    else
      Sensor.disarm(floor_number, corridor_number, sub_number)
    end
  end

  # This method runs the program but it can be refactored and moved to view.
  def inputs_runner
    loop do
      puts 'Enter commands: STATUS, EXIT, ARM, DISARM'
      command = gets.chomp.downcase
      if command.empty? || command == 'status'
        print_state
      elsif command == 'arm' || command == 'a'
        puts 'Enter floor number: '
        floor_number = gets.chomp.to_i
        puts 'Enter Corridor number: '
        corridor_number = gets.chomp.to_i
        puts 'Enter Sub Corridor number: '
        sub_number = gets.chomp.to_i

        begin
          sensor_input('arm', floor_number, corridor_number, sub_number)
        rescue ArgumentError => a
          puts a.inspect
        else
          print_state
        end
      elsif command == 'disarm'|| command == 'd'
        puts 'Enter floor number: '
        floor_number = gets.chomp.to_i
        puts 'Enter Corridor number: '
        corridor_number = gets.chomp.to_i
        puts 'Enter Sub Corridor number: '
        sub_number = gets.chomp.to_i

        begin
          sensor_input('disarm', floor_number, corridor_number, sub_number)
        rescue ArgumentError
          error.inspect
        else
          print_state
        end
      elsif command == 'exit'
        puts 'Bye bye!!'
        break
      end
    end
  end

end
