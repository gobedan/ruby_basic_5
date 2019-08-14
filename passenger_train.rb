require_relative './train.rb'

class PassengerTrain < Train
  def add_carriage(carriage)
    super if carriage.type == valid_type 
  end
  
  def get_type 
    "Passenger"
  end

  private
  #как вариант приватной константы 
  def valid_type 
    :passenger_carriage 
  end
end
