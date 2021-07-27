class Route
  attr_reader :stations

  public # Указанные ниже методы могут вызываться из клиентского кода

  def self.all
    @all ||= [ ]
  end

  def self.each(&proc)
    @all.each(&proc)
  end
  
  def initialize(station1,station2)
    @stations = [station1, station2]
    self.class.all << self
  end

  def add_station(station)
    @stations.insert(-2,station) 
  end

  def remove_station
    raise "No station to remove." if @stations.size == 2
    @stations.delete_at(-2)
  end

end