# frozen_string_literal: true

class CargoWagon < Wagon
  attr_accessor :total_volume
  attr_reader :reserved_volume

  TYPE = "Cargo"

  def initialize(railway, total_volume)
    super(railway)
    @total_volume = total_volume
    @reserved_volume = 0
    @vacant_volume = total_volume
    @number = "#{TYPE}##{number}"
  end

  def reserve_volume(volume)
    @reserved_volume += volume
    raise ArgumentError, "Can't be done. Not enough available volume." if volume > @vacant_volume
  end

  def vacant_volume
    @vacant_volume = @total_volume - @reserved_volume
  end
end
