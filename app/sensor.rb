require "observer"

class Sensor
  @@on          = false
  @@controller  = nil
  @@sensors     = {}

  include Observable
  attr_reader :id, :armed

  def initialize(id)
    @id         = id
    @armed      = false

    # Observer is added on initialization (SensorController)
    add_observer(@@controller)
  end

  # ####### Class Methods ##########
  def self.turn_on(building, controller)
    @@building   = building
    @@controller = controller
    factory
    @@on = true
  end

  def self.sensors
    @@sensors
  end

  def self.on
    @@on = true
  end

  # This can be optimize with a different query to floor/sensors
  # colleciton. Different data structures.
  def self.factory

    # Assuming 1 sensor per location
      @@building.floors.each do |floor|
        floor_number = floor[:number]

        floor[:main_corridors].each do |main|
          main_number = main[:number]
          self.create(floor_number, main_number)

          main[:sub_corridors].each do |sub|
            self.create(floor_number, main_number, sub[:number])
          end
        end
      end
  end

  # CRUD move to module if possible
  def self.create(floor_number, main_number, sub_number=0)
    # Add validation like unique ids.

    id = "#{floor_number}_#{main_number}_#{sub_number}"
    @@sensors[id] = Sensor.new(id)
  end

  def self.find; end
  def self.update; end
  def self.delete; end
  def save; end

  # ######## Instance Methods ##########
  # Observer is notified on changes (SensorController)
  def armed=(armed_update)
    changed
    @armed      = armed_update
    @last_armed = Time.now
    notify_observers(self)
  end
end
