# frozen_string_literal: true

class PassengerWagon < Wagon
  include Validation
  extend Accessors
  
  attr_accessor_with_history :total_seats
  attr_reader :reserved_seats

  validate :total_seats, :type, Integer
  validate :total_seats, :positive

  TYPE = "Passenger"

  def initialize(railway, total_seats)
    super(railway)
    @total_seats = total_seats
    validate!(:total_seats)
    @reserved_seats = 0
    @vacant_seats = total_seats
    @number = "#{TYPE}##{number}"
  end

  def reserve_seat
    raise StandardError.new, "No vacant seats remaining." if @vacant_seats.zero?
    @reserved_seats += 1
    @vacant_seats = @total_seats - @reserved_seats
  end

  def vacant_seats
    @vacant_seats
  end
end
