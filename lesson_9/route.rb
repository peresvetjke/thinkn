# frozen_string_literal: true

class Route
  include InstanceCounter
  include Validation

  attr_reader :stations
  validate :stations, :array_of_type, Station

  def initialize(railway, station1, station2)
    @stations = [station1, station2]
    validate!(:stations)
    railway.routes << self
    register_instance # InstanceCounter
  end

  def add_station(station)
    @stations.insert(-2, station)
    validate!(:stations)
  end

  def remove_station
    raise "No station to remove." if @stations.size == 2

    @stations.delete_at(-2)
  end
end
