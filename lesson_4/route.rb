class Route
  attr_reader :stations

  public # Указанные ниже методы - интерфейс класса

  def initialize(railway, station1,station2)
    @stations = [station1, station2]
    railway.routes << self
  end

  def add_station(station)
    @stations.insert(-2,station) 
  end

  def remove_station
    raise "No station to remove." if @stations.size == 2
    @stations.delete_at(-2)
  end

end