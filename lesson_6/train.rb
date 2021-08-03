class Train
  include InstanceCounter
  include Production

  TRAIN_NUMBER_FORMAT = /^([a-zA-Z0-9]{3})?(-)?([a-zA-Z0-9]{2})$/

  attr_reader :railway, :number, :location, :wagons, :route

  def self.find(train_number)
    self.all.select {|train| train.number == train_number}[0]
  end

  def initialize(railway, number)
    @number = number
    validate!
    @wagons = []
    @speed = 0
    @location = nil
    @railway = railway
    railway.trains << self
    register_instance #InstanceCounter
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  def attach_wagon(wagon)
    raise "Wagon cannot be attached if speed is not 0." if @speed != 0 
    @wagons << wagon
  end  

  def detach_wagon
    raise "Wagon cannot be detached if speed is not 0." if @speed != 0 
    @wagons.pop
  end

  def assign_route(route)
    @route = route
    @location.departure(self) if @location != nil
    route.stations[0].arrival(self)
  end

  def location
    self.railway.stations.find {|station| station.trains.include?(self)}    
  end

  def move
    temp_next_station = next_station
    raise "End of the route." if self.route.stations.index(self.location) == self.route.stations.size - 1

    self.location.departure(self)
    temp_next_station.arrival(self)
  end

  def shift
    temp_prev_location = prev_station
    raise "Start of the route." if self.route.stations.index(self.location) == 0

    self.location.departure(self)
    temp_prev_location.arrival(self)
  end

  protected 

  attr_reader :speed

  def validate!
    raise ArgumentError.new("Wrong train number format. Expecting XXX-XX or XX.") if number !~ TRAIN_NUMBER_FORMAT
  end

  def increase_speed(increase_delta)
    @speed += increase_delta
  end

  def stop
    @speed = 0
  end

  def next_station
    raise "End of the route." if self.route.stations.index(self.location) == self.route.stations.size - 1
    self.route.stations[self.route.stations.index(self.location) + 1]
  end

  def prev_station
    raise "Start of the route." if self.route.stations.index(self.location) == 0
    self.route.stations[self.route.stations.index(self.location) - 1]
  end

end