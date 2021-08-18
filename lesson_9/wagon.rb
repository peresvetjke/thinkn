# frozen_string_literal: true

class Wagon
  include InstanceCounter
  include Production
  extend Accessors

  attr_accessor :number

  def initialize(railway)
    railway.wagons << self
    register_instance # InstanceCounter
    @number = self.class.instances
  end
end
