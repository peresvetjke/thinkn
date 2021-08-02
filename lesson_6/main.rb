require_relative 'production.rb'
require_relative 'instance_counter.rb'
require_relative 'railway.rb'
require_relative 'station.rb'
require_relative 'route.rb'
require_relative 'train.rb'
require_relative 'passenger_train.rb'
require_relative 'cargo_train.rb'
require_relative 'wagon.rb'
require_relative 'passenger_wagon.rb'
require_relative 'cargo_wagon.rb'

def test_data(railway)
  station1 = Station.new(railway, "Washington")
  station2 = Station.new(railway, "Pitsburg")
  station3 = Station.new(railway, "Louisville")
  station4 = Station.new(railway, "New York")

  cargo_train1 = CargoTrain.new(railway, "Car-01")
  cargo_wagon1 = CargoWagon.new(railway)
  cargo_train1.attach_wagon(cargo_wagon1)

  passenger_train1 = PassengerTrain.new(railway, "Pas-01")
  passenger_wagon1 = PassengerWagon.new(railway)
  passenger_train1.attach_wagon(passenger_wagon1)

  station1.arrival(cargo_train1)

  route1 = Route.new(railway, station1, station4)
  route1.add_station(station2)

  passenger_train1.assign_route(route1)

  cargo_train2 = CargoTrain.new(railway, "Car-02")
end

railway1 = RailWay.new("Little Rock Railroad")
test_data(railway1)


railway1.main_menu