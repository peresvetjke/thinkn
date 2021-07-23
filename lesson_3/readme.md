Класс Station (Станция):

    Имеет название, которое указывается при ее создании
        station1 = Station.new("Pitsburg")
    Может принимать поезда (по одному за раз)
        train1 = Train.new("name","passenger",4)
    Может возвращать список всех поездов на станции, находящиеся в текущий момент
        station1.show_trains
    Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
        station1.show_trains("passenger")
        station1.show_trains("freight")
    Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
        station1.departure(train1)
        station2.arrival(train1)


Класс Route (Маршрут):

    Имеет начальную и конечную станцию, а также список промежуточных станций. Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
        route1 = Route.new(station1, station2)
    Может добавлять промежуточную станцию в список
        route1.add_point(station3)
    Может удалять промежуточную станцию из списка
        route1.remove_point
    Может выводить список всех станций по-порядку от начальной до конечной
        route1.show_list


Класс Train (Поезд):

    Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, эти данные указываются при создании экземпляра класса
        train1 = Train.new("name","passenger",4)
    Может набирать скорость
        train1.increase(10)
    Может возвращать текущую скорость
        train1.speed
    Может тормозить (сбрасывать скорость до нуля)
        train1.stop
    Может возвращать количество вагонов
        train1.wagon_amount
    Может прицеплять/отцеплять вагоны (по одному вагону за операцию, метод просто увеличивает или уменьшает количество вагонов). Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
        train1.attach_wagon
        train1.detach_wagon
    Может принимать маршрут следования (объект класса Route).
        train1.assign_route(route1) 
    При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
    Может перемещаться между станциями, указанными в маршруте. Перемещение возможно вперед и назад, но только на 1 станцию за раз.
        train1.move
        train1.shift
    Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
        train1.location
        train1.next_station
        train1.prev_station