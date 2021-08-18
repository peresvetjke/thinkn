# frozen_string_literal: true

class PassengerTrain < Train
  TYPE = "Passenger"
  
  validate :number, :format, Train::TRAIN_NUMBER_FORMAT

  def initialize(railway, number)
    super(railway, number)
    validate!(:number)
  end
end
