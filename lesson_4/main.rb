require_relative 'station.rb'
require_relative 'route.rb'
require_relative 'train.rb'
require_relative 'passenger_train.rb'
require_relative 'cargo_train.rb'
require_relative 'wagon.rb'
require_relative 'passenger_wagon.rb'
require_relative 'cargo_wagon.rb'
require_relative 'main_menu.rb'

def test_data
  station1 = Station.new("Washington")
  station2 = Station.new("Pitsburg")
  station3 = Station.new("Louisville")
  station4 = Station.new("New York")

  cargo_train1 = CargoTrain.new("Pitsburg Porter")
  cargo_wagon1 = CargoWagon.new
  cargo_train1.attach_wagon(cargo_wagon1)

  passenger_train1 = PassengerTrain.new("Washington Express")
  passenger_wagon1 = PassengerWagon.new
  passenger_train1.attach_wagon(passenger_wagon1)

  station1.arrival(cargo_train1)

  route1 = Route.new(station1, station4)
  route1.add_station(station2)

  passenger_train1.assign_route(route1)

  cargo_train2 = CargoTrain.new("New York Lofter")
end

#test_data
main_menu
