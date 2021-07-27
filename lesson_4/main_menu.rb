require_relative 'manage_routes.rb'
require_relative 'manage_trains.rb'

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

def create_station
  puts "Enter station name:"
  name = gets.chomp
  new_station = Station.new(name)
  puts "Station #{new_station.name} created."
  main_menu
end

def station_list
  stations = Station.all
  if stations.empty?
    puts "No station has been created yet"
    main_menu
  else
    puts "Choose station to view trains located there:"
    stations.each_with_index {|station, index| puts "#{index + 1}. #{station.name}"}
    station = stations[gets.chomp.to_i - 1]
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


