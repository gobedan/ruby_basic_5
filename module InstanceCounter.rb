module InstanceCounter 
  def self.included(base)
    base.extend(ClassMethods)
    base.include(InstanceMethods)
  end

  module InstanceMethods
    def register_instance
      instances_list.push(self)
    end
  end


  module ClassMethods
    def instances
      return instances_list.size
    end

    protected
    
    @instances_list = [] 

    def instances_list
      @instances_list
    end
  end

end
