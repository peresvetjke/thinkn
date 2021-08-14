# frozen_string_literal: true

class PassengerWagon < Wagon
  attr_accessor :total_seats
  attr_reader :reserved_seats

  TYPE = "Passenger"

  def initialize(railway, total_seats)
    super(railway)
    @total_seats = total_seats
    @reserved_seats = 0
    @vacant_seats = total_seats
    @number = "#{TYPE}##{number}"
  end

  def reserve_seat
    raise ArgumentError, "Can't be done. Not enough available seats." if vacant_seats.zero?

    @reserved_seats += 1
  end

  def vacant_seats
    @vacant_seats = @total_seats - @reserved_seats
  end
end
