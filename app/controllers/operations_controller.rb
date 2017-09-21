require "observer"

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

  ############## State Analisis     ####

  ############## Appliance Analisis ####

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

    if (target_sub != 0 && RESTRICTION[main_lights_always_on])

    puts "2- Analyzing and notifying from controller to Appliance"
    send_instructions_to_observer({id: id, command: command}) # this will contain the aps tree
  end

  def send_instructions_to_observer(message)
    changed
    puts "3- sending instructions"
    notify_observers({id: id, command: command}) # this will contain the aps tree
  end

end
