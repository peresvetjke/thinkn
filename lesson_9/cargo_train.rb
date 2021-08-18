# frozen_string_literal: true

class CargoTrain < Train
  TYPE = "Cargo"
  
  validate :number, :format, Train::TRAIN_NUMBER_FORMAT

  def initialize(railway, number)
    super(railway, number)
    validate!(:number)
  end
end
