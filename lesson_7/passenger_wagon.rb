class PassengerWagon < Wagon
  attr_accessor :total_seats
  TYPE = "Passenger"

  def initialize(railway, total_seats)
    super(railway)
    @total_seats = total_seats
    @reserved_seats = 0
    @vacant_seats = total_seats
    @number = "#{TYPE}##{self.number}"
  end

  def reserve_seat
    raise ArgumentError.new("Can't be done. Not enough available seats.") if self.vacant_seats == 0
    @reserved_seats += 1
  end

  def reserved_seats
    @reserved_seats
  end  

  def vacant_seats
    @vacant_seats = @total_seats - @reserved_seats
  end

end