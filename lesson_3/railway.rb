class Station
  attr_accessor :trains
  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def arrival(train)
    self.trains << train unless self.trains.include?(train)
    train.location = self
  end

  def show_trains(type="all")
    raise 'Wrong argument: use Type "passenger", "freight" or no argument (for showing full list)"' if !Train.types.include?(type) && type != "all"

    case type 
    when "all"
      puts "Trains at station #{self.name}:"
      self.trains.each {|train| puts "- #{train.number}"}
      puts "Total trains amount: #{self.trains.count}"
    when "passenger"
      passenger = self.trains.select {|train| train.type == type}
      puts "Passenger trains at station #{self.name}:"
      passenger.each {|train| puts "- #{train.number}"}
      puts "Passenger trains amount: #{passenger.count}"
    when "freight"
      freight = self.trains.select {|train| train.type == type}
      puts "Freight trains at station #{self.name}:"
      freight.each {|train| puts "- #{train.number}"}
      puts "Freight trains amount: #{freight.count}"
    end
  end

  def departure(train)
    if self.trains.include?(train)
      self.trains.delete(train)
      train.location = nil
    else
      raise "Train #{train.number} is not at the station #{self.name} now."
    end
  end
end

class Route
  attr_reader :start, :end, :points

  def initialize(station1, station2)
    @start = station1
    @end = station2
    @points = []
  end

  def add_point(station)
    self.points[self.points.size] = station
  end

  def remove_point
    raise "No point to remove." if self.points.empty?
    self.points.delete_at(self.points.size-1)
  end

  def show_list 
    puts self.start.name
    self.points.each {|station| puts station.name}
    puts self.end.name
  end

  def next_point(train)
    case train.current_route_point
    when "start"
      return self.points.empty? == true ? "end" : 0
    when "end"
      return "start"
    else
      if train.current_route_point < self.points.size - 1
        return train.current_route_point + 1
      else
        return "end"
      end
    end
  end

  def prev_point(train)
    case train.current_route_point
    when "end"
      return self.points.empty? == true ? "start" : self.points.size - 1
    when "start"
      return "end"
    else
      if train.current_route_point > 0
        return train.current_route_point - 1
      else
        return "start"
      end
    end
  end

  def location_of_next_point(train)
    case self.next_point(train)
    when "start"
      return self.start
    when "end"
      return self.end
    else
      return self.points[self.next_point(train).to_i] #return self.points[self.next_point(train).to_i] 
    end
  end

  def location_of_prev_point(train)
    case self.prev_point(train)
    when "start"
      return self.start
    when "end"
      return self.end
    else
      return self.points[self.prev_point(train).to_i] #return self.points[self.next_point(train).to_i] 
    end
  end

  def location_of_current_point(train)
    case train.current_route_point
    when "start"
      return self.start
    when "end"
      return self.end
    else
      return self.points[train.current_route_point.to_i]
    end
  end
end

class Train
  attr_reader :speed, :type, :number, :next_station, :prev_station, :types
  attr_accessor :wagons_amount, :route, :current_route_point, :location
  @@types = ["passenger", "freight"]


  def initialize(number, type, wagons_amount)
    @number = number
    @wagons_amount = wagons_amount
    @speed = 0
    raise "Wrong value for Type: can be passenger or freight" if !@@types.include?(type)
    @type = type

  end

  def self.types
    return @@types
  end
  def increase_speed(increase_delta)
    @speed += increase_delta
  end

  def stop
    @speed = 0
  end

  def attach_wagon
    raise "Wagon cannot be attached if speed is not 0." if self.speed != 0 
    self.wagons_amount += 1
  end  

  def detach_wagon
    raise "Wagon cannot be detached if speed is not 0." if self.speed != 0 
    self.wagons_amount -= 1
  end  

  def assign_route(route)
    @route = route
    @current_route_point = "start"
    self.location.departure(self) if self.location != nil
    self.route.start.arrival(self)
  end

  def prev_station
    raise "No route assigned to #{self.number}." if self.route == nil
    return  self.route.location_of_prev_point(self)
  end

  def next_station
    raise "No route assigned to #{self.number}." if self.route == nil
    return self.route.location_of_next_point(self)
  end

  def move
    raise "No route assigned to #{self.number}." if self.route == nil
    self.location.departure(self) if self.location != nil
    self.next_station.arrival(self)
    self.current_route_point = self.route.next_point(self)
  end

  def shift
    raise "No route assigned to #{self.number}." if self.route == nil
    self.location.departure(self) if self.location != nil
    self.prev_station.arrival(self)
    self.current_route_point = self.route.prev_point(self)
  end

end



















