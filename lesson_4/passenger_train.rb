class PassengerTrain < Train 

  public # метод может вызываться из клиентского кода

  def attach_wagon(wagon)
    super
    @wagons << wagon if wagon.class == PassengerWagon
  end

end