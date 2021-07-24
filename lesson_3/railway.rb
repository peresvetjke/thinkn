class Station
  attr_accessor :trains
  attr_reader :name

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

  def trains_by_type(type)
    raise "Wrong value for Type: can be passenger or freight" if !TYPES.include?(type)
    @trains.select {|train| train.type == type}
  end

  def count_trains_by_type(type)
    raise "Wrong value for Type: can be passenger or freight" if !TYPES.include?(type)
    self.trains_by_type(type).count
  end
  
end

class Route
  attr_reader :stations
  
  def initialize(station1,station2)
    @stations = [station1, station2]
  end

  def add_station(station)
    @stations.insert(-2,station) 
  end

  def remove_station
    raise "No station to remove." if @stations.size == 2
    @stations.delete_at(-2)
  end

end

class Train
TYPES = ["passenger", "freight"]

  attr_reader :speed, :type, :number
  attr_accessor :wagons_amount, :route, :location
  

  def initialize(number, type, wagons_amount)
    @number = number
    @wagons_amount = wagons_amount
    @speed = 0
    @location = nil
    raise "Wrong value for Type: can be passenger or freight" if !TYPES.include?(type)
    @type = type
  end

  def increase_speed(increase_delta)
    @speed += increase_delta
  end

  def stop
    @speed = 0
  end

  def attach_wagon
    raise "Wagon cannot be attached if speed is not 0." if @speed != 0 
    @wagons_amount += 1
  end  

  def detach_wagon
    raise "Wagon cannot be detached if speed is not 0." if @speed != 0 
    @wagons_amount -= 1
  end  

  def assign_route(route)
    @route = route
    @location.departure(self) if @location != nil
    route.stations[0].arrival(self)
  end


  def location
    Station.all.find {|station| station.trains.include?(self)}    
  end

  def next_station(current_station = self.location)
    raise "End of the route." if self.route.stations.index(current_station) == self.route.stations.size - 1
    self.route.stations[self.route.stations.index(current_station) + 1]
  end


  def prev_station(current_station = self.location)
    raise "Start of the route." if self.route.stations.index(current_station) == 0
    self.route.stations[self.route.stations.index(current_station) - 1]
  end

  def move
    temp_location = self.location
    raise "End of the route." if self.route.stations.index(temp_location) == self.route.stations.size - 1

    temp_location.departure(self)
    next_station(temp_location).arrival(self)
  end

  def shift
    temp_location = self.location
    raise "Start of the route." if self.route.stations.index(temp_location) == 0

    temp_location.departure(self)
    prev_station(temp_location).arrival(self)
  end

end