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
    @view           = args[:view]

    add_observer(@appliance)
  end

  # Turn on:
  #   => Create all sensors per floor
  #   => Create all appliances per floor
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

    # Dispatch instructions related to lights appliances
    # Checks for target main or sub and its corresponding configuration
    if (target_sub == 0 && !RESTRICTION[:main_lights_always_on] || target_sub != 0 && !RESTRICTION[:sub_lights_always_on])
      send_instructions_to_observer({id: "#{sensor.id}", command: command, type: 'light', energy_balance: nil})
    end

    energy_balance = @building.restrictions[target_floor.to_s] - @appliance.energy_report[target_floor.to_s][:current_usage]

    # Dispatch instructions related to air conditioning appliances upon energy analysis
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

  # Print states using view
  def print_state
    @view.print_state
  end

end
