class Station
  attr_reader :name, :trains

  public # Указанные ниже методы могут вызываться из клиентского кода

  def self.all
    @all ||= [ ]
  end

  def self.each(&proc)
    @all.each(&proc)
  end

  def initialize(name)
    @name = name
    @trains = []
    Station.all << self
  end

  def arrival(train)
    raise "Train is already at the station." if @trains.include?(train)
    raise "Train at another station now." if Station.all.select {|station| station.trains.include?(train)}.empty? == false
    @trains << train
  end

  def departure(train)
    raise "Train is not at the station now." if !@trains.include?(train) 
    @trains.delete(train)
  end
  
end

