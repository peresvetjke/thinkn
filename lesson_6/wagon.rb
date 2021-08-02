class Wagon
  include InstanceCounter
  include Production

  def initialize(railway)
    railway.wagons << self
    register_instance #InstanceCounter
  end

end