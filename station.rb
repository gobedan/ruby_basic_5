require_relative './instance_list.rb'
require_relative './instance_counter.rb'

class Station
  include InstanceCounter, InstanceList

  attr_reader :trains, :name

  def initialize(name)
    @name = name
    @trains = [] 
    self.register_instance
    self.register_instance_in_list
  end

  def self.all
    instance_list
  end
 
  def trains_by_type(type)
    return trains.collect { |train|  train if train.type == type }  
  end

  def accept_train(train) 
    trains.push(train) unless trains.include?(train)
  end

  def depart_train(train)
    trains.delete(train) if trains.include?(train)
  end
end
