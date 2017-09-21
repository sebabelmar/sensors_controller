require "observer"

class Sensor
  include Observable

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
    @armed      = armed_update
    @last_armed = Time.now
    notify_observers(self)
  end


  # ####### Class Methods & Vars ##########
  @@controller  = nil
  @@sensors     = {}

  def self.turn_on(building, controller)
    @@building   = building
    @@controller = controller
    factory
  end

  # This can be optimize with a different query to floor/sensors
  # colleciton. Different data structures.
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

  # CRUD move to module if possible
  def self.create(location, floor_number, main_number, sub_number=0)
    # Add validation like unique ids.

    id = "#{floor_number}_#{main_number}_#{sub_number}"
    @@sensors[id] = Sensor.new({
      id: id, floor_number: floor_number, location: location
      })
  end

  def self.all
    @@sensors
  end

  # I would make this method more flexible
  def self.arm(floor_number, corridor_number, sub_number=0)
    @@sensors["#{floor_number}_#{corridor_number}_#{sub_number}"].armed = true
  end

  def self.disarm(floor_number, corridor_number, sub_number=0)
    @@sensors["#{floor_number}_#{corridor_number}_#{sub_number}"].armed = false
  end

  # Potential CRUD API or it can be turn into a different data structure
  # def self.find; end
  # def self.update; end
  # def self.delete; end
  # def save; end
end
