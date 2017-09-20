class Appliance

  @@appliances = {}

  attr_reader :floor_number, :energy_consuption
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

  def self.update(banana)
    puts '--- APPLIANCE GETTING MESSAGE AS CLASS ---'
  end

  def self.all
    @@appliances
  end

  def self.turn_on(building)
    @@building  = building
    factory(@@building.appliances_config)
  end

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

  def self.print_state
    puts "------------------"
    puts "State Report"
    puts "------------------"
    @@building.floors_config.each do |floor|
      puts "Floor #{floor[:number]}"

      floor[:main_corridors].each do |main|
        puts "  Main corridor #{main[:number]}"
        puts "  Light: #{@@appliances["#{floor[:number]}_#{main[:number]}_0_light"].on ? 'ON' : 'OFF'}"
        puts "  AC: #{@@appliances["#{floor[:number]}_#{main[:number]}_0_ac"].on ? 'ON' : 'OFF'}"

        main[:sub_corridors].each do |sub|
          puts "    Main corridor #{sub[:number]}"
          puts "      Light: #{@@appliances["#{floor[:number]}_#{main[:number]}_#{sub[:number]}_light"].on ? 'ON' : 'OFF'}"
          puts "      AC: #{@@appliances["#{floor[:number]}_#{main[:number]}_#{sub[:number]}_ac"].on ? 'ON' : 'OFF'}"
        end
      end
    end
    puts "------------------"
  end

  def self.energy_report
    floors_array  = (1..@@building.floors_config.length).to_a
    report_hash   = Hash.new {0}
    apps          = @@appliances.values

    floors_array.each do |floor|
      report_hash[floor.to_s] =  apps.select {|app| app.floor_number == floor && app.on}.map(&:energy_consuption).reduce(:+)
    end

    report_hash
  end

end
