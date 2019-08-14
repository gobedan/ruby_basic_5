require_relative './instance_counter.rb'
require_relative './instance_list.rb'
require_relative './company_info.rb'

class Train 
  include InstanceCounter, InstanceList, CompanyInfo

  attr_reader :id, :route

  def initialize(id)
    @id = id
    @carriages = []
    self.register_instance
    self.register_instance_in_list
  end

  def self.find(id)
    instance_list.select { |train| train.id == id }.first
  end

  def route=(route)
      #уберем поезд со станции если переназначили маршрут 
    current_station.depart_train(self) if self.route
    @route = route
    self.current_station_index = 0 
    current_station.accept_train(self) 
  end
  
  def current_station
    route.route_list[current_station_index] if route
  end

  def next_station
    route.route_list[current_station_index + 1] if route && current_station_index + 1 < route.route_list.size
  end

  def prev_station
    #[current_station_index - 1] распознает как обращение как геттеру с аргументом ArgumentError
    route.route_list[current_station_index + -1] if route && current_station_index > 0
  end

  def remove_carriage
    carriages.pop 
  end
  
  def add_carriage(carriage)
    carriages.push(carriage)
  end

  def carriages_count
    carriages.size
  end

  def go_next
    self.current_station_index += 1 if go(next_station)
  end

  def go_back  
    self.current_station_index -= 1 if go(prev_station)
  end

  protected 

  attr_reader  :carriages
  attr_accessor :current_station_index
  #или лучше private?
  def go(station)
    if station
      current_station.depart_train(self)
      station.accept_train(self)
    end
  end
end
