# frozen_string_literal: true

class Train
  include InstanceCounter
  include Production
  include Validation
  extend Accessors

  TRAIN_NUMBER_FORMAT = /^([a-zA-Z0-9]{3})?(-)?([a-zA-Z0-9]{2})$/.freeze

  attr_reader :number, :railway, :wagons, :route
  validate :number, :format, TRAIN_NUMBER_FORMAT

  def self.find(train_number)
    all.select { |train| train.number == train_number }[0]
  end

  def initialize(railway, number)
    @number = number
    validate!(:number)
    @wagons = []
    @speed = 0
    @location = nil
    @railway = railway
    railway.trains << self
    register_instance # InstanceCounter
  end

  def attach_wagon(wagon)
    raise "Wagon cannot be attached if speed is not 0." if @speed != 0

    @wagons << wagon
  end

  def detach_wagon
    raise "Wagon cannot be detached if speed is not 0." if @speed != 0

    @wagons.pop
  end

  def location
    railway.stations.find { |station| station.trains.include?(self) }
  end

  def assign_route(route)
    @route = route
    location&.departure(self)
    route.stations.first.arrival(self)
  end

  def move
    temp_next_station = next_station
    raise "End of the route." if route.stations.index(location) == route.stations.size - 1

    location.departure(self)
    temp_next_station.arrival(self)
  end

  def shift
    temp_prev_location = prev_station
    raise "Start of the route." if route.stations.index(location).zero?

    location.departure(self)
    temp_prev_location.arrival(self)
  end

  def wagons_list
    return unless block_given?

    wagons.each_with_index do |wagon, index|
      wagon_info = { obj: wagon, number: wagon.number, type: wagon.class::TYPE }
      if wagon.instance_of?(PassengerWagon)
        wagon_info[:vacant] = wagon.vacant_seats
        wagon_info[:reserved] = wagon.reserved_seats
      elsif wagon.instance_of?(CargoWagon)
        wagon_info[:vacant] = wagon.vacant_volume
        wagon_info[:reserved] = wagon.reserved_volume
      end
      yield(index, wagon_info)
    end
  end

  protected

  attr_reader :speed

  def increase_speed(increase_delta)
    @speed += increase_delta
  end

  def stop
    @speed = 0
  end

  def next_station
    raise "End of the route." if route.stations.index(location) == route.stations.size - 1

    route.stations[route.stations.index(location) + 1]
  end

  def prev_station
    raise "Start of the route." if route.stations.index(location).zero?

    route.stations[route.stations.index(location) - 1]
  end
end
