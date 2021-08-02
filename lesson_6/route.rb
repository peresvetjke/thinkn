class Route
  include InstanceCounter
  attr_reader :stations

  # Указанные ниже методы - интерфейс класса

  def initialize(railway, station1, station2)
    @stations = [station1, station2]
    railway.routes << self
    register_instance #InstanceCounter
    validate!
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  def validate!
    @stations.each{|station| raise ArgumentError.new("Wrong input. Exptecting Station class.") if station.class != Station}
  end

  def add_station(station)
    @stations.insert(-2,station) 
    validate!
  end

  def remove_station
    raise "No station to remove." if @stations.size == 2
    @stations.delete_at(-2)
  end

end