require "observer"

class Sensor
  include Observable
  attr_reader :id, :floor, :corridor, :armed, :last_armed

  def initialize(args={})
    @id         = args[:id]
    @floor      = args[:floor]
    @corridor   = args[:corridor]
    @armed      = args[:armed]
    @last_armed = args[:last_armed]
    @observer   = args[:observer]

    # Observer is added on initialization (SensorController)
    add_observer(@observer)
  end


  # Observer is notified on changes (SensorController)
  def armed=(armed_update)
    changed
    @armed = armed_update
    notify_observers(self)
  end
end
