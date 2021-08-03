class Station
  include InstanceCounter
  attr_reader :name, :trains

  def initialize(railway, name)
    @name = name
    validate!
    @trains = []
    @railway = railway
    railway.stations << self
    register_instance #InstanceCounter
  end
  
  def valid?
    validate!
    true
  rescue
    false
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
  
  private

  def validate!
    raise ArgumentError.new('Station name must be have at least 4 characters long.') if name.length < 4
  end

end

