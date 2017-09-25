  # Description:
#   This class is an appliance factory
#   Its instances recieves instrunctions from the controller. Via the Class.
#   OperationsController gets this class as an observer.
#   Its responsability is to create instances upon floor configuration, maintain
#   a collection of instances in compliance with the provided configuration. It
#   provides energy consuption reports to evaluate current state.
#   This class should not be instantiated manually.

# Dependencies: n/a

# Attributes:
#   args= {
#     id: "<floor_number>_<main_corridor_number>_<sub_corridor_or_zero>_<type>",,
#     type: <ligt || ac>,
#     energy_consuption: <number>,
#     floor_number: <number>,
#     location: <main || sub>,
#     number: <number>,
#     on: <bolean>,
#   }

# External API:
#         class:
#           .turn_on(<building instance>)  => Allocates arguments to class variables
#                                          => Executes factory method
#           .update(<message>)             => Used by Obserbable to notify state changes.
#           .perform_operation(<message>)  => Given a message from update makes appliaces react.
#                                          => Message = {id: <string>, command: <on || off> , type: <ligt || ac>, energy_balance: <number>}
#           .all                           => returns a collection of appliances created upon Bulding#appliances_config; @@appliances
#           .energy_report                 => returns a an object informing current status per floor.
#                                             {
#                                               "1"=>{:current_usage=>40, :saving_mode=>true},
#                                               "2"=>{:current_usage=>35, :saving_mode=>true}
#                                             }
#           .find(type, floor_number, corridor_number, sub_number=0)
#                                          => Given set of parameters finds an element in its collection.
#         instance:
#           #on                            => Attribute accesor to change instance state.
#           #floor_number, #energy_consuption, #type, #location
#                                          => Attribute reader.

class Appliance

  @@appliances = {}
  @@on = false

  attr_reader :floor_number, :energy_consuption, :type, :location
  attr_accessor :on

  def initialize(args)
    @id                = args[:id]
    @type              = args[:type]
    @energy_consuption = args[:energy_consuption]
    @floor_number      = args[:floor_number]
    @location          = args[:location]
    @number            = args[:number]
    @on                = args[:on]
  end

  # Recieves message from OperationsController
  def self.update(message)
    perform_operation(message)
  end

  # Performs logic to turn on an off appliances. Lights first then AC.
  def self.perform_operation(message)
    target_floor, target_corridor, target_sub = message[:id].split('_')

    appliance_id = "#{message[:id]}_#{message[:type]}"

    if(message[:type] == 'light')
      @@appliances[appliance_id].on = message[:command] == 'on'
    elsif(message[:type] == 'ac' && message[:command] == 'off')
      # Finds an AC that is on in an specific floor and location
      subs_acs_on = @@appliances.values.select { |app|
        app.floor_number.to_s == target_floor && app.location == 'sub' && app.on == true && app.type == 'ac'
      }

      # In the case of finding more thate one takes a sample and turns off.
      target_applience = subs_acs_on.sample
      target_applience.on = false
    elsif(message[:type] == 'ac' && message[:command] == 'on')
      # Finds an AC that is off in an specific floor and location
      subs_acs_off = @@appliances.values.select { |app|
        app.floor_number.to_s  == target_floor && app.location == 'sub' && app.on == false && app.type == 'ac'
      }

      # In the case of finding more that one takes a sample and turns on checking
      # available energy.
      target_applience = subs_acs_off.sample
      target_applience.on = true if message[:energy_balance] >= target_applience.energy_consuption
    end
  end

  # Returns collection
  def self.all
    @@appliances
  end

  # Turns the class on, creating collection of instances of it self
  def self.turn_on(building)
    @@building  = building
    factory(@@building.appliances_config) unless @@on
  end

  # Given a appliances configuration executes initialization upon building floor
  # configuration.
  def self.factory(appliances_config)
      appliances_config.each do |app|
        type              = app[:type]
        energy_consuption = app[:energy_consuption]
        create_main       = app[:location] == 'main'
        create_sub        = app[:location] == 'sub'

        @@building.floors_config.each do |floor|
          floor_number = floor[:number]

          floor[:main_corridors].each do |main|
            main_number = main[:number]
            self.create(type, energy_consuption, 'main', true, floor_number, main_number) if create_main

            main[:sub_corridors].each do |sub|
              on = type == 'ac' ? true : false
              self.create(type, energy_consuption, 'sub' , on, floor_number, main_number, sub[:number]) if create_sub
            end
          end
        end
      end
  end

  # Creates instances of itself and it organize it in a Hash were the keys are the elements ids
  # and values are instances of this same class.
  def self.create(type, energy_consuption, location, on, floor_number, main_number, sub_number=0)
    # Add validation like unique ids.
    id = "#{floor_number}_#{main_number}_#{sub_number}_#{type}"

    @@appliances[id] = Appliance.new({
      id: id,
      type: type,
      on: on,
      floor_number: floor_number,
      number: location == 'main' ? main_number : sub_number,
      location: location,
      energy_consuption: energy_consuption
    })
  end

  # From applainces collection creates an energy report
  def self.energy_report
    floors_array  = (1..@@building.floors_config.length).to_a
    report_hash   = Hash.new {0}
    apps          = @@appliances.values

    floors_array.each do |floor|
      saving_mode   = apps.select {|app| app.floor_number == floor && app.type == 'ac' && app.on == false}.length != 0
      current_usage = apps.select {|app| app.floor_number == floor && app.on}.map(&:energy_consuption).reduce(:+)
      report_hash[floor.to_s] = {current_usage: current_usage, saving_mode: saving_mode}
    end

    report_hash
  end

  # Returns an instances given parametes to find it on appliances collection
  def self.find(type, floor_number, corridor_number, sub_number=0)
    @@appliances["#{floor_number}_#{corridor_number}_#{sub_number}_#{type.downcase}"]
  end

end
