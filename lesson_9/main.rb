# frozen_string_literal: true

require_relative 'production'
require_relative 'instance_counter'
require_relative 'accessors'
require_relative 'validation'
require_relative 'railway'
require_relative 'station'
require_relative 'route'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require 'pry'

def test_data(railway)
  station1 = Station.new(railway, "Washington")
  station2 = Station.new(railway, "Pitsburg")
  station3 = Station.new(railway, "Louisville")
  station4 = Station.new(railway, "New York")

  passenger_train1 = PassengerTrain.new(railway, "Pas-01")
  passenger_wagon1 = PassengerWagon.new(railway, 20)
  passenger_wagon2 = PassengerWagon.new(railway, 20)
  passenger_wagon3 = PassengerWagon.new(railway, 20)
  passenger_train1.attach_wagon(passenger_wagon1)
  passenger_train1.attach_wagon(passenger_wagon2)
  passenger_train1.attach_wagon(passenger_wagon3)

  station1.arrival(passenger_train1)

  route1 = Route.new(railway, station1, station4)
  route1.add_station(station2)

  cargo_train1 = CargoTrain.new(railway, "Car-01")
  cargo_wagon1 = CargoWagon.new(railway, 100)
  cargo_train1.attach_wagon(cargo_wagon1)
  cargo_train1.assign_route(route1)

  cargo_train2 = CargoTrain.new(railway, "Car-02")
  cargo_wagon2 = CargoWagon.new(railway, 100)
  cargo_train2.attach_wagon(cargo_wagon2)

  cargo_wagon2.reserve_volume(40)
  5.times  { passenger_wagon1.reserve_seat }
  19.times { passenger_wagon2.reserve_seat }
end

def test_data_meta(railway)
  puts '--------attr_accessor_with_history--------'
  passenger_wagon1 = PassengerWagon.new(railway, 20)
  puts "Checking attribute getter... "
  puts "passenger_wagon1.total_seats = #{passenger_wagon1.total_seats}"                 
  puts "Checking history getter..."
  puts "passenger_wagon1.total_seats_history = #{passenger_wagon1.total_seats_history}" 
  puts "Checking attribute setter..."
  passenger_wagon1.total_seats = 25
  puts "Checking history updating..."                                                     
  puts "passenger_wagon1.total_seats_history = #{passenger_wagon1.total_seats_history}" 

  puts '--------strong_attr_accessor--------------'
  cargo_wagon1 = CargoWagon.new(railway, 100)
  puts "Checking setter with correct type of value."
  cargo_wagon1.total_volume = 200.0
  puts "cargo_wagon1.total_volume = #{cargo_wagon1.total_volume}"
  puts "Checking setter with wrong type of value..."
  begin
    cargo_wagon1.total_volume = 'one hundred'
  rescue StandardError => e
    puts "Checking the error message..."
    puts "#{e}" 
  end

  puts '--------validate-------------------------'
  puts "Checking valid? with correct type of value..."
  puts "passenger_wagon1.valid?(:total_seats) = #{passenger_wagon1.valid?(:total_seats)}" 
  puts "Checking vlidate! with wrong type of value..."
  begin
    passenger_wagon2 = PassengerWagon.new(railway, 20.5) 
  rescue StandardError => e
    puts "Checking the message..."
    puts "#{e}" 
  end

end


railway1 = RailWay.new("Little Rock Railroad")
test_data_meta(railway1)
# test_data(railway1)
# railway1.main_menu

