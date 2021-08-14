# frozen_string_literal: true

class RailWay
  attr_accessor :stations, :trains, :wagons, :routes
  attr_reader :name

  def initialize(name)
    @stations = []
    @trains = []
    @wagons = []
    @routes = []
    @name = name
    validate!
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def main_menu
    puts '---------------------------'
    puts "Main menu:"
    puts "1. Create station"
    puts "2. Manage trains"
    puts "3. Manage routes"
    puts "4. List station's trains and wagons"
    puts "5. List all stations, trains and wagons"

    input = gets.chomp.to_i
    case input
    when 1
      create_station
    when 2
      manage_trains
    when 3
      manage_routes
    when 4
      station_list
      main_menu
    when 5
      all_stations_list
      main_menu
    else
      puts "Wrong input."
      main_menu
    end
  end

  def manage_routes
    puts '---------------------------'
    puts "Manage routes:"
    puts "1. Create new route"
    puts "2. Add station to route"
    puts "3. Delete station from route"
    puts "4. Show routes list"
    puts "5. Assign route to train"
    puts "6. Go to Trains menu"
    puts "0. Go to Main menu"

    input = gets.chomp.to_i

    case input
    when 1
      create_route
    when 2
      add_station_to_route
    when 3
      delete_station_from_route
    when 4
      routes_list
      manage_routes
    when 5
      assign_route_to_train
      manage_routes
    when 6
      manage_trains
    when 0
      main_menu
    else
      puts "Wrong input"
      manage_routes
    end
  end

  def manage_trains
    puts '---------------------------'
    puts "Manage trains:"
    puts "1. Create new train"
    puts "2. Attach wagon to train"
    puts "3. Detach wagon from train"
    puts "4. Show train's wagons list"
    puts "5. Reserve seat (or volume) in wagon"
    puts "6. Move train forward  (on route)"
    puts "7. Move train backward (on route)"
    puts "8. Assign route to train"
    puts "9. Go to Route menu"
    puts "0. Go to Main menu"

    input = gets.chomp.to_i

    case input
    when 1
      create_train
    when 2
      train = select_train
      attach_wagon_to_train(train)
    when 3
      train = select_train
      detach_wagon_from_train(train)
    when 4
      train = select_train
      show_wagons_by_train(train)
      manage_trains
    when 5
      train = select_train
      wagon = select_wagon(train)
      if train.instance_of?(PassengerTrain)
        reserve_seat(wagon)
      elsif train.instance_of?(CargoTrain)
        reserve_volume(wagon)
      end
      manage_trains
    when 6
      move_train
    when 7
      shift_train
    when 8
      assign_route_to_train
      manage_trains
    when 9
      manage_routes
    when 0
      main_menu
    else
      puts "Wrong input."
      manage_trains
    end
  end

  private

  def validate!
    raise ArgumentError, 'Railway name must be have at least 4 characters long.' if name.length < 4
  end

  def create_station
    puts "Enter station name:"
    name = gets.chomp
    Station.new(self, name)
    puts "Station #{name} created."
    main_menu
  end

  def all_stations_list
    puts '---------------------------'
    if stations.empty?
      puts "No station has been created yet"
    else
      stations.each_with_index do |station, s_index|
        puts "#{s_index + 1}. #{station.name}"
        if station.trains.empty?
          puts "There is no train at the station now."
        else
          station.train_list do |t_index, train_info|
            puts "#{s_index + 1}.#{t_index + 1}. Train number: #{train_info[:number]} | type: #{train_info[:type]} | wagons: #{train_info[:wagons]}"
            if train_info[:obj].wagons.size.zero?
              puts "Train has no attached wagons."
            else
              train_info[:obj].wagons_list do |w_index, wagon_info|
                puts "#{s_index + 1}.#{t_index + 1}.#{w_index + 1}. wagon number: #{wagon_info[:number]} | type: #{wagon_info[:type]} | " \
                                                                   "vacant: #{wagon_info[:vacant]} | reserved: #{wagon_info[:reserved]}"
              end
            end
          end
        end
      end
    end
    main_menu
  end

  def station_list
    if stations.empty?
      puts "No station has been created yet"
      main_menu
    else
      puts "Choose station to view trains located there:"
      stations.each_with_index { |station, index| puts "#{index + 1}. #{station.name}" }
      station = stations[gets.chomp.to_i - 1]

      if station.trains.empty?
        puts "There is no train at the station now."
      else
        station.train_list do |t_index, train_info|
          puts "#{t_index + 1}. Train number: #{train_info[:number]} | type: #{train_info[:type]} | wagons: #{train_info[:wagons]}"
          if train_info[:obj].wagons.size.zero?
            puts "Train has no attached wagons."
          else
            train_info[:obj].wagons_list do |w_index, wagon_info|
              puts "#{t_index + 1}.#{w_index + 1}. wagon number: #{wagon_info[:number]} | type: #{wagon_info[:type]} | " \
                                                  "vacant: #{wagon_info[:vacant]} | reserved: #{wagon_info[:reserved]}"
            end
          end
        end
      end
    end
  end

  def create_train
    puts "Choose train type:"
    puts "1. Passenger"
    puts "2. Cargo"
    type = gets.chomp.to_i
    begin
      puts "Enter name/number of the train:"
      number = gets.chomp
      new_train = type == 1 ? PassengerTrain.new(self, number) : CargoTrain.new(self, number)
      new_train.valid?
      puts "Train #{new_train.number} created."
    rescue StandardError
      puts "Wrong train number format. Expecting XXX-XX or XX."
      retry
    end
    manage_trains
  end

  def attach_wagon_to_train(train)
    if train.instance_of?(PassengerTrain)
      puts "Enter total seats amount:"
      seats_amount = gets.chomp.to_i
      wagon = PassengerWagon.new(self, seats_amount)
    elsif train.instance_of?(CargoTrain)
      puts "Enter total volume:"
      total_volume = gets.chomp.to_i
      wagon = CargoWagon.new(self, total_volume)
    end
    train.attach_wagon(wagon)
    puts "Wagon #{wagon.number} attached to the train."
    manage_trains
  end

  def detach_wagon_from_train(train)
    if train.wagons.size.zero?
      puts "Train has no wagons."
    else
      train.detach_wagon
      puts "Wagon has been detached."
    end
    manage_trains
  end

  def reserve_seat(passenger_wagon)
    if passenger_wagon.vacant_seats.positive?
      passenger_wagon.reserve_seat
      puts "Seat was reserved in wagon #{passenger_wagon.number}."
    else
      puts "Can't be done. Available seats amount in wagon is: #{passenger_wagon.vacant_seats}."
    end
  end

  def reserve_volume(cargo_wagon)
    puts "Enter volume amount to reserve:"
    volume = gets.chomp.to_i
    if cargo_wagon.vacant_volume >= volume
      cargo_wagon.reserve_volume(volume)
      puts "#{volume} volume was reserved in wagon #{cargo_wagon.number}."
    else
      puts "Can't be done. Available volume in wagon is: #{cargo_wagon.vacant_volume}."
    end
  end

  def select_wagon(train)
    if train.wagons.empty?
      puts "Wagon has no attached wagons."
      manage_trains
    else
      show_wagons_by_train(train)
      puts "Choose wagon:"
      train.wagons[gets.chomp.to_i - 1]
    end
  end

  def show_wagons_by_train(train)
    if train.wagons.size.zero?
      puts "Train has no attached wagons."
    else
      puts "Wagons list of #{train.number}"
      train.wagons_list do |index, wagon_info|
        puts "#{index + 1}. number: #{wagon_info[:number]} | type: #{wagon_info[:type]} | " \
                           "vacant: #{wagon_info[:vacant]} | reserved: #{wagon_info[:reserved]}"
      end
    end
  end

  def select_train
    if trains.empty?
      puts "No train has been created yet."
      manage_trains
    else
      puts "Choose train:"
      trains.each_with_index { |train, ind| puts "#{ind + 1}. #{train.number}" }
      trains[gets.chomp.to_i - 1]
    end
  end

  def move_train
    train = select_train
    current_location = train.location
    if train.route.nil?
      puts "Train has no assigned route."
    elsif train.route.stations.index(train.location) == train.route.stations.size - 1
      puts "End of the route. Train can't be moved."
    else
      train.move
      puts "Train was moved from #{current_location.name} to #{train.location.name}."
    end
    manage_trains
  end

  def shift_train
    train = select_train
    current_location = train.location
    if train.route.nil?
      puts "Train has no assigned route."
    elsif train.route.stations.index(train.location).zero?
      puts "Start of the route. Train can't be moved."
    else
      train.shift
      puts "Train was moved backward from #{current_location.name} to #{train.location.name}."
    end
    manage_trains
  end

  def create_route
    if stations.empty?
      puts "No station has been created yet."
      main_menu
    else
      puts "Stations:"
      stations.each_with_index { |station, index| puts "#{index + 1}. #{station.name}" }
      puts "Creating route:"
      print "Enter start station - "
      a = gets.chomp.to_i
      print "Enter end station - "
      b = gets.chomp.to_i
      new_route = Route.new(self, stations[a - 1], stations[b - 1])
      puts "Route between stations #{new_route.stations.first.name} and #{new_route.stations.last.name} created."
    end
    manage_routes
  end

  def add_station_to_route
    route = select_route
    station = select_station
    route.add_station(station)
    route_stations = []
    route.stations.each { |stat| route_stations << stat.name }
    puts "Route updated: #{route_stations}"
    manage_routes
  end

  def delete_station_from_route
    route = select_route
    if route.stations.size == 2
      puts "No more station to delete from route."
    else
      route.remove_station
      route_stations = []
      route.stations.each { |station| route_stations << station.name }
      puts "Route updated: #{route_stations}"
    end
    manage_routes
  end

  def assign_route_to_train
    train = select_train
    route = select_route
    train.assign_route(route)
    puts "Route assigned."
  end

  def select_station
    puts "Choose station:"
    if stations.empty?
      puts "No station has been created yet."
      main_menu
    else
      stations.each_with_index { |station, index| puts "#{index + 1}. #{station.name}" }
    end
    stations[gets.chomp.to_i - 1]
    # station = stations[gets.chomp.to_i - 1]
  end

  def select_route
    routes_list
    route_number = gets.chomp.to_i
    routes[route_number - 1]
    # route = routes[route_number - 1]
  end

  def routes_list
    if routes.empty?
      puts "No route has been created yet."
      manage_routes
    else
      puts "Routes:"
      routes.each_with_index do |route, index|
        route_stations = []
        route.stations.each { |station| route_stations << station.name }
        puts "#{index + 1}. #{route_stations}"
      end
    end
  end
end
