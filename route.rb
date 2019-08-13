class Route 
  include InstanceCounter

  attr_reader :route_list

  def initialize(first, last)
    @route_list = [first, last]
    self.register_instance
  end

  def add_station(station)
    route_list.push(station)
  end

  def remove_station(station)
    route_list.delete(station) if route_list.size > 2 
  end
end
