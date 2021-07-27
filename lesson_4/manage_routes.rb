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

def create_route
  stations = Station.all
  if stations.empty?
    puts "No station has been created yet."
    main_menu
  else
    puts "Stations:"
    stations.each_with_index {|station, index| puts "#{index + 1}. #{station.name}"}
    puts "Creating route:"
    print "Enter start station - "
    a = gets.chomp.to_i
    print "Enter end station - "
    b = gets.chomp.to_i
    new_route = Route.new(stations[a - 1], stations[b - 1])
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
  stations = Station.all
  if stations.empty?
    puts "No station has been created yet."
    main_menu
  else
    stations.each_with_index {|station, index| puts "#{index + 1}. #{station.name}"}
  end
  station = stations[gets.chomp.to_i - 1]
end

def select_route
  routes_list
  route_number = gets.chomp.to_i
  route = Route.all[route_number - 1]
end

def routes_list
  routes = Route.all
  if routes.empty?
    puts "No route has been created yet."
    manage_routes
  else
    puts "Routes:"
    routes.each_with_index do |route, index| 
      route_stations = []
      route.stations.each {|station| route_stations << station.name}
      puts "#{index + 1}. #{route_stations}"
    end
  end
end