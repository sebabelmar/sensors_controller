require "observer"
require "byebug"

class OperationsController
  include Observable
  attr_reader :on, :test_var

  def initialize(args)
    @test_var       = nil
    @on             = false
    @building       = args[:building]
    @sensor         = args[:sensor]
    @appliance      = args[:appliance]

    add_observer(@appliance)
  end

  # Turn on:
  #   => Create all sensors per floor
  #   => Create all apps per floor as off
  #   => Sets levels of energy in use somewhere
  def turn_on
    @sensor.turn_on(@building, self)
    @appliance.turn_on(@building)
    @on = true
  end


  ############## MESSAGES ##############
  # Receives messages from sensors.
  # Executes changes on 'state'
  def update(sensor)
    # 1- This should trigger a state analysis
    analyze(sensor)
  end

  # Emits messages to appliances
  def analyze(sensor)
    target_floor, target_corridor, target_sub = sensor.id.split('_')
    command = sensor.armed ? 'on' : 'off'

    #  1- turn on || off ligts
    #  2- perform energy analysis to the floor
    #  3- turn on || off ac
    # We could add a check for not repeating opperations

    # Checks for target main or sub and its corresponding configuration
    if (target_sub == 0 && !RESTRICTION[:main_lights_always_on] || target_sub != 0 && !RESTRICTION[:sub_lights_always_on])
      send_instructions_to_observer({id: "#{sensor.id}", command: command, type: 'light', energy_balance: nil})
    end

    energy_balance = @building.restrictions[target_floor.to_s] - @appliance.energy_report[target_floor.to_s][:current_usage]

    if (energy_balance < 0)
      send_instructions_to_observer({id: "#{sensor.id}", command: 'off', type: 'ac', energy_balance: energy_balance})
    elsif(energy_balance > 0 && @appliance.energy_report[target_floor.to_s][:saving_mode])
      send_instructions_to_observer({id: "#{sensor.id}", command: 'on', type: 'ac', energy_balance: energy_balance})
    end
  end

  def send_instructions_to_observer(message)
    changed
    notify_observers(message)
  end

end
