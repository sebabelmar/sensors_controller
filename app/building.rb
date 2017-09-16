class Building
  def initialize(args={})

    if ([args[:floor_qty], args[:main_corridors_per_floor], args[:sub_corridors_per_floor]].uniq.include?(nil))
      raise(ArgumentError, "You must include all of the following arguments in numeric values and 0 if n.a: floor_qty, main_corridors_per_floor, sub_corridors_per_floor.")
    end

    args.reject { |k, v| [:category].include? k }.each do |k, v|
      raise(ArgumentError, "#{k} is not  numeric value.") unless v.class == Fixnum
    end


    # Building Classification
    @category                   = args[:category] || 'hotel'

    # Structure
    @number_of_floors           = args[:floor_qty]
    @number_of_floors           = args[:floor_qty]
    @main_corridors_per_floor   = args[:main_corridors_per_floor]
    @sub_corridors_per_floor    = args[:sub_corridors_per_floor]

    # Apliance per corridor
    @lights_per_main_corridors  = args[:lights_per_main_corridors]  || 1
    @lights_per_sub_corridors   = args[:lights_per_sub_corridors]   || 1
    @ac_per_main_corridors      = args[:ac_per_main_corridors]      || 1
    @ac_per_sub_corridors       = args[:ac_per_sub_corridors]       || 1

  end
end
