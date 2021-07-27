class Train

  public # Указанные ниже методы могут вызываться из клиентского кода

  attr_reader :number, :location, :wagons, :route

  def self.all
    @all ||= [ ]
  end

  def self.each(&proc)
    @all.each(&proc)
  end

  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
    @location = nil
    self.class.all << self
  end

  def attach_wagon(wagon)
    raise "Wagon cannot be attached if speed is not 0." if @speed != 0 
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
    Station.all.find {|station| station.trains.include?(self)}    
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

=begin
  Указанные ниже методы не должны вызываться из клиентского кода. 
  Изменение скорости не входило в требования (задание) к интерфейсу, 
  вместе с этим по логике изменение скорости может повлиять на успешность 
  прикрепления вагонов. 
  Методы пока оставляем, так как они могут пригодится в будущем
=end
  attr_reader :speed

  def increase_speed(increase_delta)
    @speed += increase_delta
  end

  def stop
    @speed = 0
  end



=begin
  next_station и prev_station не должны напрямую вызываться из клиентского кода (они
  используются внутри других методов класса - move и shift соответственно.
  Хотя оставить их в public также будет не критично. Но интерфейсом класса они не являются.
  Плюс вызываться они будут от потомков, а не от данного суперкласса -> protected.
=end


  def next_station
    raise "End of the route." if self.route.stations.index(self.location) == self.route.stations.size - 1
    self.route.stations[self.route.stations.index(self.location) + 1]
  end

  def prev_station
    raise "Start of the route." if self.route.stations.index(self.location) == 0
    self.route.stations[self.route.stations.index(self.location) - 1]
  end

end