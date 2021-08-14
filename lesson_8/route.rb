# frozen_string_literal: true

class Route
  include InstanceCounter

  attr_reader :stations

  def initialize(railway, station1, station2)
    @stations = [station1, station2]
    railway.routes << self
    register_instance # InstanceCounter
    validate!
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def add_station(station)
    @stations.insert(-2, station)
    validate!
  end

  def remove_station
    raise "No station to remove." if @stations.size == 2

    @stations.delete_at(-2)
  end

  private

  def validate!
    @stations.each { |station| raise ArgumentError, "Wrong input. Exptecting Station class." if station.class != Station }
  end
end
