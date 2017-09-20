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
    @sensor.turn_on
    @appliance.turn_on
    @on = true
  end

  # Turn to activated:
  #   => Set all main light on
  #   => Set all sub lights to motion
  #   => Set all AC to on
  #   => Runs energy analysis


  ############## State Analisis     ####

  ############## Appliance Analisis ####

  ############## MESSAGES ##############
  # Receives messages from sensors.
  # Executes changes on 'state'
  def update(sensor)
    # 1- This should trigger a state analysis
    # 2- Updates the Appliance tree (representation of the apliances)
    # 3- Send new Appliance Tree to Appliance via messages
    # puts "Updated from a sensor..."
    # self.state = state << sensor.id
    # print_this
    @test_var = true
  end

  # Emits messages to appliances
  def state=(state)
    changed
    @state = state
    puts "State Updated notify appliances.... bip bip"

    notify_observers(self) # this will contain the aps tree
  end
end
