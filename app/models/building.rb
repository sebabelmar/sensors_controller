# Description:
#   This class is the entry point of the system's configuration.
#   Its responsability is to be source of truth for configurations
#   and energy restrictions. An instance of this class is a dependency for
#   OperationsController, Appliance and Sensor .turn_on

# Dependencies: n/a

# Attributes:
#   args= {
#     category: <String>,
#     floors_config: FLOORS_CONFIGS[],
#     appliances_config: APPLIANCES_CONFIGS[],
#     restriction: {}
#   }

# External API: n/a

class Building
  attr_reader :restrictions
  attr_accessor :restriction, :floors_config, :appliances_config, :sensors, :restrictions

  def initialize(args={})

    # Validations
    # This validation can be moved to a module and that performs more generic checks
    floors_config     = args[:floors_config] || raise(ArgumentError, "Please check floors_config format and data types.")
    appliances_config = args[:appliances_config] || raise(ArgumentError, "Please check appliances_config format and data types.")
    restriction       = args[:restriction] || raise(ArgumentError, "Please check restriction format and data types.")

    check_floors_config_elements_class       = floors_config.map(&:class).uniq.pop == Hash
    check_floors_config_elements_consistency = floors_config.map {|config| [config[:number].class, config[:main_corridors].class]}.flatten.uniq == [Fixnum, Array]

    check_appliances_config_elements_class       = appliances_config.map(&:class).uniq.pop == Hash
    check_appliances_config_elements_consistency = appliances_config.map {|config| [config[:qty_per_location].class, config[:energy_consuption].class]}.flatten.uniq == [Fixnum]

    check_restriction_config_numeric_elements_consistency = appliances_config.map {|config| [config[:main_times].class, config[:sub_times].class]}.flatten.uniq == [Fixnum]

    unless (floors_config.class == Array && check_floors_config_elements_class && check_floors_config_elements_consistency)
      # This check can be extended to become more specific to different potential issues.
      raise(ArgumentError, "Please check floors_config format and data types.")
    end

    unless (appliances_config.class == Array && check_appliances_config_elements_class && check_appliances_config_elements_consistency)
      # This check can be extended to become more specific to different potential issues.
      raise(ArgumentError, "Please check appliaces_config format and data types.")
    end

    unless (restriction.class == Hash || check_restriction_config_numeric_elements_consistency )
      # This check can be extended to become more specific to different potential issues.
      raise(ArgumentError, "Please check restriction_config hash format and data types.")
    end

    # Building Classification
    @category = args[:category] || 'hotel'

    # Structure
    @floors_config = floors_config
    @appliances_config = appliances_config
    @sensors_config = restriction

    # Features
    @restriction = args[:restriction]
    @restrictions = energy_restrictions
  end

  private

    # Creates hash with restriciton per floor
    def energy_restrictions
      @floors_config.each_with_object({}) do |floor, restrictions|
          limit = 0 # hard coded numbre red flag!

          floor[:main_corridors].each do |main|
            limit += @restriction[:main_times]

            main[:sub_corridors].each do |sub|
              limit += @restriction[:sub_times]
            end
          end

          restrictions[floor[:number].to_s] = limit
      end
    end
end
