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
      var_name = "@#{name}".to_sym
      self.class.validations[name.to_sym].each do |validation|
        validation_type = validation.first
        argument = validation.last
        case validation_type
        when :presence
          raise TypeError.new "'#{name.to_s}' should not be nil." if (instance_variable_get(var_name).nil? || instance_variable_get(var_name) == '')
        when :format
          raise TypeError.new "Wrong format for '#{name.to_s}' (expecting '#{argument}')." if instance_variable_get(var_name) !~ argument
        when :type
          raise TypeError.new "Wrong type for '#{name.to_s}' (expecting '#{argument}')." if instance_variable_get(var_name).class != argument
        when :array_of_type  
          instance_variable_get(var_name).each { |element| raise TypeError.new "Wrong type for '#{element}' (expecting '#{argument}')." if element.class != argument }
        when :positive
          raise TypeError.new "'#{name.to_s}' should not be negative.)." if instance_variable_get(var_name) < 0
        end
      end
      true
    end

  end
end