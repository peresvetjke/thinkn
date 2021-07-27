class Wagon
  def initialize(railway)
    railway.wagons << self
  end
end