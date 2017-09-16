require "observer"

class SensorController
  include Observable
  attr_reader :status, :state

  def initialize(observer)
    @status = 'on'
    @state = []
    @observer = observer

    add_observer(@observer)
  end

  # Receives messages from sensors
  def update(sensor)
    # This should trigger a state analysis and update the
    # Appliance tree (representation of the apliances)
    puts "Updated from a sensor..."
    self.state = state << sensor.id
  end

  # Emits messges to appliances
  def state=(state)
    changed
    @state = state
    puts "State Updated notify appliances.... bip bip"

    notify_observers(self) # this will contain the aps tree
  end
end
