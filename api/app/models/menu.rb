class Menu
  attr_reader :id, :nombre, :precio, :peso
  attr_accessor :id

  def initialize(id, nombre, precio, peso = 1)
    @id = id
    @nombre = nombre
    @precio = precio
    @peso = peso
  end
end
