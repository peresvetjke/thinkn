class Wagon
  
  public # Указанные ниже методы могут вызываться из клиентского кода

  def self.all
    @all ||= [ ]
  end

  def self.each(&proc)
    @all.each(&proc)
  end

  def initialize
    self.class.all << self
  end
end