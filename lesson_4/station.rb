class Station
  attr_reader :name, :trains

  # Указанные ниже методы - интерфейс класса

  def initialize(railway, name)
    @name = name
    @trains = []
    @railway = railway
    railway.stations << self
  end

  def arrival(train)
    #raise "Train is already at the station." if @trains.include?(train)
    #raise "Train at another station now." if @railway.stations.select {|station| station.trains.include?(train)}.empty? == false
    @trains << train
  end

  def departure(train)
    #raise "Train is not at the station now." if !@trains.include?(train) 
    @trains.delete(train)
  end
  
end

