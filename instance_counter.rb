module InstanceCounter 
  def self.included(base)
    base.extend(ClassMethods)
    base.include(InstanceMethods)
    #Другие способы подмешать инстанс переменную класс-уровня не сработали
    base.instance_variable_set(:@instances_count, 0)
  end

  module InstanceMethods
    
    protected
    
    def register_instance
      self.class.instances_count = self.class.instances + 1 
    end
  end


  module ClassMethods

    def instances
      return @instances_count
    end

    #как это инкапсулировать? 
    attr_writer :instances_count

    private 
    #Необходимо для наследования переменной дочерними классами содержащими эту примесь 
    def inherited(subclass)
      subclass.instance_variable_set(:@instances_count, 0)
    end
  end

end
