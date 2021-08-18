module Accessors

  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      var_name_history = "@#{name}_history".to_sym

      define_method("#{name}_history=".to_sym) { |value| instance_variable_set(var_name_history, value) }
      define_method("#{name}_history".to_sym) do 
        if instance_variable_get(var_name_history).nil?
          instance_variable_set(var_name_history, instance_variable_get(var_name).nil? ? [] : [instance_variable_get(var_name)]) 
        end
        instance_variable_get(var_name_history)
      end

      define_method("#{name}") { instance_variable_get(var_name) }
      define_method("#{name}=".to_sym) do |value| 
        instance_variable_set(var_name_history, (self.send ("#{name}_history".to_sym)).push(value))
        instance_variable_set(var_name, value)
      end
    end
  end

  def strong_attr_accessor(*names, type)
    names.each do |name|
      var_name = "@#{name}".to_sym

      define_method("#{name}".to_sym) { instance_variable_get(var_name) }
      define_method("#{name}=".to_sym) do |value| 
        raise TypeError.new, "Wrong type for #{var_name} (expecting '#{type}'." if value.class != type
        instance_variable_set(var_name, value) 
      end
    end
  end
end

class Dog
  extend Accessors

  attr_accessor_with_history :name
  strong_attr_accessor :age, Integer

  def initialize(name)
    @name = name
  end
end