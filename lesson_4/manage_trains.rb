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

def create_train
  puts "Choose train type:"
  puts "1. Passenger"
  puts "2. Cargo"
  type = gets.chomp.to_i
  puts "Enter name/number of the train:"
  number = gets.chomp
  new_train = type == 1 ? PassengerTrain.new(number) : CargoTrain.new(number)
  puts "Train #{new_train.number} created."
  manage_trains
end

def attach_wagon_to_train
  train = select_train
  if train.class == PassengerTrain
    wagon = PassengerWagon.new
  else
    wagon = CargoWagon.new
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
  if PassengerTrain.all.empty? && CargoTrain.all.empty?
    puts "No train has been created yet."
    manage_trains
  else
    trains = []
    trains << PassengerTrain.all
    trains << CargoTrain.all
    puts "Choose train:"
    trains.flatten.each_with_index {|train, ind| puts "#{ind + 1}. #{train.number}"}
    return trains.flatten[gets.chomp.to_i - 1]
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

