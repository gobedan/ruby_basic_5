require_relative './train.rb'
require_relative './station.rb'
require_relative './route.rb'
require_relative './passenger_carriage.rb'
require_relative './cargo_carriage.rb'
require_relative './passenger_train.rb'
require_relative './cargo_train.rb'

class MainMenu

  def initialize
    init_text
    @trains = [] 
    @routes = [] 
    @stations = [] 
  end

  def main_menu(command)
    case command
      when '1'  
        create_station 
      when '2'  
        create_train
      when '3'  
        create_route
      when '4'  
        configure_route
      when '5'  
        configure_train
      when '6'  
        station_full_info
      when 'help'  
        init_text  
      when 'exit'
        return
    else
      puts 'Wrong input! Type "help" for instructions'
    end
  end

  private 

  attr_reader :trains, :routes, :stations

  def create_station
    puts "Enter new station name: "
    print ":> > "
    station_name = gets.chomp
    stations.push(Station.new(station_name))
  end

  def create_train
    puts "Enter new train ID: "
    print ":> > "
    train_id = gets.chomp
    puts "Choose train type: 1 - Passenger, 2 - Cargo  "
    loop do
      print ":> > > "
      user_input = gets.chomp
      case user_input
        when '1'  
          trains.push(PassengerTrain.new(train_id))
          # break в кейсе для выхода из loop! 
          break 
        when '2'  
          trains.push(CargoTrain.new(train_id))
          break  
        when 'exit'  
          break  
      else
        puts "Wrong input!"
      end
    end
  end

  def create_route
    if stations.size >= 2 
      puts "Choose start station (1..#{stations.size})"
      start_station = station_chooser
      puts "Start"
      puts "  |1.#{start_station.name}"
      puts "  |2. ..."
      puts "End"
      puts "Choose end station (1..#{stations.size})"
      end_station = station_chooser
      puts "Start"
      puts "  |1.#{start_station.name}"
      puts "  |2.#{end_station.name}"
      puts "End"
      routes.push(Route.new(start_station, end_station))
    else
      puts "Create more stations first!"
    end
  end

  def configure_route
    puts "Select route ..."
    #выходим из метода если список для выбора пуст
    return unless selected_route = route_chooser
    puts "Selected: #{print_single_route(selected_route)}"
    puts "Command list: "
    puts "1. Add station"
    puts "2. Remove station"
    puts "  (Route cannot be left with less than 2 stations)"
    puts "exit. for exit"
    loop do
      print ":> > > "
      user_input = gets.chomp
      case user_input
        when '1'  
            selected_route.add_station(station_chooser)     
            print_single_route(selected_route)      
        when '2'  
          if selected_route.route_list.size <= 2
            puts "Route cannot be less than 2 stations!" 
          else 
            selected_route.remove_station(station_chooser) 
            print_single_route(selected_route)     
          end
        when 'exit'  
          #для выхода из loop 
          break  
      else
        puts 'Wrong input!'
      end
    end
  end

  def configure_train
    puts "Select train ... "
    #выходим из метода если список для выбора пуст
    return unless selected_train = train_chooser
    puts "Command list: "
    puts "1. Assign route"
    puts "2. Add carriage"
    puts "3. Remove carriage"
    puts "4. Go to the next station"
    puts "5. Go one station back"
    puts "exit. for exit"
    puts "Selected: "
    loop do
      print_single_train(selected_train)
      print ":> > > "
      user_input = gets.chomp
      case user_input
        when '1'  
            selected_train.route = route_chooser unless routes.empty? 
        when '2'  
            if selected_train.get_type == "Passenger"
              selected_train.add_carriage(PassengerCarriage.new)
            elsif selected_train.get_type == "Cargo"
              selected_train.add_carriage(CargoCarriage.new)
            end
        when '3'  
            selected_train.remove_carriage
        when '4'  
            selected_train.go_next
        when '5'  
            selected_train.go_back
        when 'exit'  
          break  
      else
        puts 'Wrong input!'
      end
    end
  end

  def station_list
    counter = 0 
    stations.each do |station| 
      print "#{counter += 1}. "
      puts "#{station.name}"
    end
  end

  def route_list
    counter = 0 
    routes.each do |route| 
      print "#{counter += 1}. "
      print_single_route(route)
    end
  end

  def train_list
    counter = 0 
    trains.each do |train| 
      print "#{counter += 1}. "
      print_single_train(train) 
    end
  end

  def route_chooser 
    if !routes.empty?
      route_list
      loop do
        print ":> > "
        user_input = gets.chomp.to_i
        break routes[user_input - 1] if  routes[user_input - 1] && user_input != 0  
      end
    else 
      puts "No routes was created yet!"
    end
  end

  def station_chooser
    if !stations.empty?
      station_list
      loop do
        print ":> > "
        user_input = gets.chomp.to_i
        break stations[user_input - 1] if stations[user_input - 1] && user_input != 0 
        puts "Wrong station number!"
      end
    else 
      puts "No stations was created yet!"
    end
  end

  def train_chooser 
    if !trains.empty?
      train_list
      loop do
        print ":> > "
        user_input = gets.chomp.to_i
        break trains[user_input - 1] if trains[user_input-1] && user_input != 0 
      end
    else 
      puts "No trains was created yet!"  
    end
  end

  def print_single_route(route)
    if route 
      route.route_list.each { |station| print "[#{station.name} -> " }
      puts "]"
    else
      puts " - "
    end
  end

  def print_single_train(train)
    puts "ID: #{train.id}, Type: #{train.get_type}, Carriages: #{train.carriages_count}"
    print "  Route: " 
    print_single_route(train.route)
    print "    Current station: "
    print_single_station(train.current_station)
  end

  def print_single_station(station)
    if station
      puts "#{station.name}" 
    else 
      puts " - "
    end
  end

  def station_full_info
    if !stations.empty? 
      station_counter = 0 
      stations.each do |station| 
        print "#{station_counter += 1}. "
        puts "#{station.name}"
        train_counter = 0
        puts "Trains on this station: "
        station.trains.each do |train| 
          print "<<<< #{train_counter += 1}. "
          print_single_train(train) 
        end
      end
    else
      puts "Create at least one station first!"
    end
  end

  def init_text 
    puts "Command list: "
    puts "'1' = Create new station"
    puts "'2' = Create new train"
    puts "'3' = Create new route"
    puts "'4' = Configure route"
    puts "'5' = Configure train"
    puts "'6' = Stations info"
    puts "'help' = print command list"
    puts "'exit' = exit"
  end
=begin
  def seed 
    trains.push(CargoTrain.new("1022-1"))
    trains.push(PassengerTrain.new("2244-02b"))
    stations.push(Station.new("Penza gruzovoy-1"))
    stations.push(Station.new("Kharkov"))
    stations.push(Station.new("Moscow, Kievskiy railway"))
    stations.push(Station.new("SPB"))
    routes.push(Route.new(stations[0], stations[1]))
  end
=end
end

menu = MainMenu.new 

loop do 
  puts "Main menu:"
  print ":> "
  user_input = gets.chomp 
  menu.main_menu(user_input)
  break if user_input == 'exit'
end
