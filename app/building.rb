=begin
This class is ment to be a simple building configuration

Properties Types:
  @category: String
  @floors: floor[]
    floor = {number:<1>, qty_main_corridor:<1>, qty_sub_corr:<1>}
  @appliances: appliance[]
    appliance = {type: <light, ac>, location: <main, sub>, qty_per_location: <=1>, energy_consuption<10>}
  @sensors = sensor[]
    sensor = {type: <motion>, location: <main, sub>, qty_per_location: <=1>}
  @restriction = Hash
    {level: floor, :main_times: , :sub_times}
=end


class Building
  attr_reader :restrictions
  attr_accessor :restriction, :floors, :sensors, :restrictions

  def initialize(args={})
    # Verify objects keys and values...
    if (false)
      raise(ArgumentError, "some error")
    end

    # Building Classification
    @category = args[:category] || 'hotel'

    # Structure
    @floors = args[:floors]

    # Features
    @appliances = args[:appliances]
    @sensors = args[:sensors]
    @restriction = args[:restriction]
    @restrictions = energy_restrictions
  end

  private
    # Restriction flex draft (energy_restrictions)
    # def restriction=(new_restriction);end

    # Creates hash with restriciton per floor
    def energy_restrictions
      @floors.each_with_object({}) do |floor, restrictions|          
          limit = 0

          floor[:main_corridors].each do |main|
            limit += @restriction[:main_times]

            main[:sub_corridors].each do |sub|
              limit += @restriction[:sub_times]
            end
          end

          restrictions[floor[:number]] = limit
      end
    end
end
