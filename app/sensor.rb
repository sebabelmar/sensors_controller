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

    add_observer(@observer)
  end

  def armed=(armed_update)
    changed
    @armed = armed_update
    notify_observers(self)
  end
end
