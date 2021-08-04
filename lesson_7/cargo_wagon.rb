class CargoWagon < Wagon
  attr_accessor :total_volume
  TYPE = "Cargo"

  def initialize(railway, total_volume)
    super(railway)
    @total_volume = total_volume
    @reserved_volume = 0
    @vacant_volume = total_volume
    @number = "#{TYPE}##{self.number}"
  end

  def reserve_volume(volume)
    @reserved_volume += volume
    raise ArgumentError.new("Can't be done. Not enough available volume.") if volume > @vacant_volume
  end

  def reserved_volume
    @reserved_volume
  end  

  def vacant_volume
    @vacant_volume = @total_volume - @reserved_volume
  end

end