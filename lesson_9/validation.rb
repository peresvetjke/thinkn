module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :validations

    def validate(name, validation_type, argument = nil)
      var_name = "#{name}".to_sym
      @validations ||= {}
      @validations[var_name] ||= []
      @validations[var_name] << [validation_type, argument] 
    end
  end

  module InstanceMethods
    def valid?(name)
      validate!(name)
      true
    rescue
      false
    end

    def validate!(name)
      self.class.validations[name.to_sym].each do |validation|
        validation_type = validation.first
        argument = validation.last
        self.send "validate_#{validation_type}".to_sym, name, *argument
      end
      true
    end

    private

    def validate_presence(name)
      var_name = "@#{name}".to_sym
      raise TypeError.new "'#{name.to_s}' should not be nil." if (instance_variable_get(var_name).nil? || instance_variable_get(var_name) == '')
    end

    def validate_format(name, argument)
      var_name = "@#{name}".to_sym
      raise TypeError.new "Wrong format for '#{name.to_s}' (expecting '#{argument}')." if instance_variable_get(var_name) !~ argument
    end

    def validate_type(name, argument)
      var_name = "@#{name}".to_sym
      raise TypeError.new "Wrong type for '#{name.to_s}' (expecting '#{argument}')." if instance_variable_get(var_name).class != argument
    end

    def validate_array_of_type(name, argument)
      var_name = "@#{name}".to_sym
      instance_variable_get(var_name).each { |element| raise TypeError.new "Wrong type for '#{element}' (expecting '#{argument}')." if element.class != argument }
    end

    def validate_positive(name)
      var_name = "@#{name}".to_sym
      raise TypeError.new "'#{name.to_s}' should not be negative.)." if instance_variable_get(var_name) < 0
    end
  end
end