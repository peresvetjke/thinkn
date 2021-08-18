# frozen_string_literal: true

class CargoWagon < Wagon
  include Validation
  extend Accessors

  attr_reader :reserved_volume
  
  strong_attr_accessor :total_volume, Float
  validate :total_volume, :positive

  TYPE = "Cargo"

  def initialize(railway, total_volume)
    super(railway)
    @total_volume = total_volume.to_f
    validate!(:total_volume)
    @reserved_volume = 0
    @vacant_volume = total_volume.to_f
    @number = "#{TYPE}##{number}"
  end

  def reserve_volume(volume)
    raise StandardError.new, "Vacant volume is not enough." if @vacant_volume < volume
    @reserved_volume += volume.to_f
    @vacant_volume = @total_volume - @reserved_volume
  end

  def vacant_volume
    @vacant_volume
  end
end
