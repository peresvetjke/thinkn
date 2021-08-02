class RailWay
  attr_accessor :stations, :trains, :wagons, :routes
  attr_reader :name

  # Указанные ниже методы - интерфейс класса: 
  # Это инициализация железной дороги + реализация текстового интерфейса для пользователя.
  # Можно было в принципе оставить только только main_menu.

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
  rescue
    false
  end
  
  def validate!
    raise ArgumentError.new('Railway name must be have at least 4 characters long.') if name.length < 4
  end

  def main_menu
    puts '---------------------------'
    puts "Main menu:"
    puts "1. Create station"
    puts "2. Manage trains"
    puts "3. Manage routes"
    puts "4. List stations"

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
    puts "3. Detach wagon to train"
    puts "4. Move train forward  (on route)"
    puts "5. Move train backward (on route)"
    puts "6. Assign route to train"
    puts "7. Go to Route menu"
    puts "0. Go to Main menu"

    input = gets.chomp.to_i

    case input
    when 1
      create_train
    when 2
      attach_wagon_to_train
    when 3
      detach_wagon_from_train
    when 4
      move_train
    when 5
      shift_train
    when 6
      assign_route_to_train
      manage_trains
    when 7
      manage_routes
    when 0
      main_menu
    else
      puts "Wrong input."
      manage_trains
    end

  end

  private 
  # Вызов указанных ниже методов извне данного класса не предполагается.
  
  def create_station
    puts "Enter station name:"
    name = gets.chomp
    new_station = Station.new(self, name)
    puts "Station #{name} created."
    main_menu
  end

  def station_list
    if self.stations.empty?
      puts "No station has been created yet"
      main_menu
    else
      puts "Choose station to view trains located there:"
      self.stations.each_with_index {|station, index| puts "#{index + 1}. #{station.name}"}
      station = self.stations[gets.chomp.to_i - 1]
      trains_on_station(station)
    end
  end

  def trains_on_station(station)
    if station.trains.empty?
      puts "There is no train at the station now."
    else
      puts "List of the trains at station:"
      station.trains.each_with_index {|train, index| puts "#{index + 1}. #{train.number}"}
    end
    main_menu
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
    rescue 
      puts "Wrong train number format. Expecting XXX-XX or XX."
      retry
    end
    manage_trains
  end

  def attach_wagon_to_train
    train = select_train
    if train.class == PassengerTrain
      wagon = PassengerWagon.new(self)
    else
      wagon = CargoWagon.new(self)
    end
    train.attach_wagon(wagon)
    puts "Wagon attached to the train."
    manage_trains
  end

  def detach_wagon_from_train
    train = select_train
    if train.wagons.size == 0
      puts "Train has no wagons."
    else
      train.detach_wagon
      puts "Wagon has been detached."
    end
    manage_trains
  end

  def select_train
    if self.trains.empty?
      puts "No train has been created yet."
      manage_trains
    else
      puts "Choose train:"
      self.trains.each_with_index {|train, ind| puts "#{ind + 1}. #{train.number}"}
      return self.trains[gets.chomp.to_i - 1]
    end
  end

  def move_train
    train = select_train
    current_location = train.location
    if train.route == nil
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
    if train.route == nil
      puts "Train has no assigned route."
    elsif train.route.stations.index(train.location) == 0
      puts "Start of the route. Train can't be moved."
    else
      train.shift
      puts "Train was moved backward from #{current_location.name} to #{train.location.name}."
    end
    manage_trains
  end

  def create_route
    if self.stations.empty?
      puts "No station has been created yet."
      main_menu
    else
      puts "Stations:"
      self.stations.each_with_index {|station, index| puts "#{index + 1}. #{station.name}"}
      puts "Creating route:"
      print "Enter start station - "
      a = gets.chomp.to_i
      print "Enter end station - "
      b = gets.chomp.to_i
      new_route = Route.new(self, self.stations[a - 1], self.stations[b - 1])
      puts "Route between stations #{new_route.stations.first.name} and #{new_route.stations.last.name} created."
    end
    manage_routes
  end

  def add_station_to_route
    route = select_route
    station = select_station
    route.add_station(station)
    route_stations = []
    route.stations.each {|station| route_stations << station.name}
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
      route.stations.each {|station| route_stations << station.name}
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
    if self.stations.empty?
      puts "No station has been created yet."
      main_menu
    else
      self.stations.each_with_index {|station, index| puts "#{index + 1}. #{station.name}"}
    end
    station = self.stations[gets.chomp.to_i - 1]
  end

  def select_route
    routes_list
    route_number = gets.chomp.to_i
    route = self.routes[route_number - 1]
  end

  def routes_list
    if self.routes.empty?
      puts "No route has been created yet."
      manage_routes
    else
      puts "Routes:"
      self.routes.each_with_index do |route, index| 
        route_stations = []
        route.stations.each {|station| route_stations << station.name}
        puts "#{index + 1}. #{route_stations}"
      end
    end
  end

end 