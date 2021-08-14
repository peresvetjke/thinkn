# frozen_string_literal: true

class Station
  include InstanceCounter
  attr_reader :name, :trains

  def initialize(railway, name)
    @name = name
    validate!
    @trains = []
    @railway = railway
    railway.stations << self
    register_instance # InstanceCounter
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def arrival(train)
    raise "Train is already at the station." if @trains.include?(train)
    raise "Train at another station now." if @railway.stations.select do |station|
                                               station.trains.include?(train)
                                             end.empty? == false

    @trains << train
  end

  def departure(train)
    raise "Train is not at the station now." unless @trains.include?(train)

    @trains.delete(train)
  end

  def train_list
    return unless block_given?
    trains.each_with_index do |train, index|
      train_info = { obj: train, number: train.number, type: train.class::TYPE, wagons: train.wagons.size }
      yield(index, train_info)
    end
  end

  private

  def validate!
    raise ArgumentError, 'Station name must be have at least 4 characters long.' if name.length < 4
  end
end
